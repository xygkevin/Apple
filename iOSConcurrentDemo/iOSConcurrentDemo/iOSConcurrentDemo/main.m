//
//  main.m
//  iOSConcurrentDemo
//
//  Created by uwei on 2019/3/5.
//  Copyright © 2019 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <pthread.h>
#import "MyConcurrentOperation.h"
#import "MyNonConcurrentOperation.h"

#define kCondition 0
#define kOperation 0
#define kSerial 0
#define kConcurrent 0
#define kPatchGroup 0
#define kWorkloop 1

@interface Singleton : NSObject
+ (instancetype)instance;
@end

static Singleton *s;
@implementation Singleton

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s == nil) {
            s = [[Singleton alloc] init];
        }
    });
    return s;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keypath:%@, change:%@", keyPath, change);
}

@end



@interface MyCustomClass : NSObject
- (NSOperation *)taskWithData:(id)data;
- (NSOperation *)taskWithBlock:(id)data;
@end
@implementation MyCustomClass

- (NSOperation *)taskWithData:(id)data {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskMethod:) object:data];
    return op;
}

- (NSOperation *)taskWithBlock:(id)data {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"do block1 task on thread %@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"do block2 task on thread %@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"do block3 task on thread %@", [NSThread currentThread]);
    }];
    return op;
}


- (void)taskMethod:(id)data {
    NSLog(@"do invocation task on thread %@", [NSThread currentThread]);
}

@end




@interface ThreadObject : NSObject

@property (copy, nonatomic) NSString *resource;

- (void)task1:(NSString *)p;
- (void)task2;

@end

@implementation ThreadObject

int gX = 0;

- (void)task1:(NSString *)p {
    @synchronized (@(gX)) {
        NSLog(@"%@ %d", self.resource, gX);
    }
    
    if ([p isEqualToString:@"!"]) {
        // the priority is determined by the kernel, there is no guarantee what this value actually will be
        NSLog(@"%@", [NSThread setThreadPriority:0.2] ? @"YES" : @"NO");
    }
    mach_port_t machTID = pthread_mach_thread_np(pthread_self());
    NSLog(@"%s[%@], current thread: %x[%@] priority(%f), process id:%d", __FUNCTION__, p, machTID, [NSThread currentThread], [[NSThread currentThread] threadPriority], NSProcessInfo.processInfo.processIdentifier);
}

- (void)task2 {
    self.resource = @"set";
    @synchronized (@(gX)) {
         gX++;
    }
   
}

@end




int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
#pragma mark - Operation
        //        [[[[MyCustomClass alloc] init] taskWithData:nil] start];
        NSOperationQueue* q = [[NSOperationQueue alloc] init];
        q.maxConcurrentOperationCount = 3;
        [q addOperation:[[MyCustomClass new] taskWithData:nil]];
        [q addOperation: [[MyCustomClass new] taskWithBlock:nil]];
        [q addOperation:[[MyNonConcurrentOperation alloc] initWithData:nil]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        [q addOperation:[[MyConcurrentOperation alloc] init]];
        //        [[[MyNonConcurrentOperation alloc] initWithData:nil] start];
#pragma mark - GCD
        // 并发队列
        __unused dispatch_queue_t gq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 串行队列, 第二个参数不填写默认是串行
        __unused dispatch_queue_t usq = dispatch_queue_create("com.demo.queue", NULL);
        __unused dispatch_queue_t csq = dispatch_get_current_queue();
#if 0
        NSLog(@"isMultiThreaded :%d", [NSThread isMultiThreaded]);
        ThreadObject *to1 = [ThreadObject new];
        for (int i = 0; i < 2; ++i) {
            NSThread *thread1 = [[NSThread alloc] initWithTarget:to1 selector:@selector(task1:) object:@"hello"];
            [thread1 start];
            NSLog(@"isMultiThreaded :%d", [NSThread isMultiThreaded]);
            [NSThread detachNewThreadSelector:@selector(task1:) toTarget:to1 withObject:@"world"];
            NSLog(@"isMultiThreaded :%d", [NSThread isMultiThreaded]);
            
            NSThread *thread2 = [[NSThread alloc] initWithTarget:to1 selector:@selector(task1:) object:@"!"];
            // the priority is determined by the kernel, there is no guarantee what this value actually will be
            [thread2 setThreadPriority:0.1];
            [thread2 start];
            
            [NSThread detachNewThreadSelector:@selector(task2) toTarget:to1 withObject:nil];
        }
#endif
//        OSQueueHead q = OS_ATOMIC_QUEUE_INIT;
        NSMutableArray *shareArray = [NSMutableArray new];
        //        __block volatile int index = 0;
        __block int index = 0;
        //        OSAtomicEnqueue( &q, &index, sizeof(int));
        //        OSAtomicEnqueue( &q, &index, sizeof(int));
#if kCondition
        NSCondition *lock = [[NSCondition alloc] init];
        //        NSCondition *lock = nil;
        while (1) {
            [NSThread detachNewThreadWithBlock:^{
                [lock lock];
                while (index >= 5) {
                    [lock wait];
                    NSLog(@"wait....");
                }
                for (int i = 0; i < 5; ++i) {
                    [shareArray insertObject:@(i) atIndex:index++];
                    NSLog(@"producer :%d", index);
                }
                [lock unlock];
            }];
            
            [NSThread detachNewThreadWithBlock:^{
                [lock lock];
                for (int i = 0; i < 5; ++i) {
                    
                    if (index >= 1) {
                        [shareArray removeObjectAtIndex:--index];
                        NSLog(@"consumer :%d", index);
                    }
                    
                }
                [lock signal];
                
                [lock unlock];
            }];
        }
#elif kOperation
        // 默认队列支持串行和并行
        NSOperationQueue *oq = [[NSOperationQueue alloc] init];
        [oq addObserver:[Singleton instance] forKeyPath:@"maxConcurrentOperationCount" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld context:nil];
        oq.name = @"test.queue";
        // 默认，-1(NSOperationQueueDefaultMaxConcurrentOperationCount),表示不限制并行数量（坑!）
        // 1，串行队列
        // > 1, 并行队列
        oq.maxConcurrentOperationCount = 4; //(which is recommended) // 最好是根据核数
        while (1) {
            //            NONCurrentOperation *CCO = [[NONCurrentOperation alloc] initWithData:@[@"name1 ", @"name2"]];
            //            [oq addOperation:CCO];
            
            NSBlockOperation *po = [NSBlockOperation blockOperationWithBlock:^{
                NSLog(@"NSOperationQueue producer :%d", index);
                [shareArray addObject:@(index++)];
            }];
            
            NSBlockOperation *co = [NSBlockOperation blockOperationWithBlock:^{
                for (id object in shareArray) {
                    NSLog(@"NSOperationQueue consumer :%@", object);
                }
                [shareArray removeAllObjects];
            }];
            // 如果是串行，则不需要依赖
            // 如果是并行，则需要依赖，否则对可变内存就会出现IO问题，需要加同步锁
            [co addDependency:po];
            [oq addOperation:co];
            [oq addOperation:po];
            [oq waitUntilAllOperationsAreFinished];
        }
        
#elif kSerial
        dispatch_queue_t sq = dispatch_queue_create("sq.demo", DISPATCH_QUEUE_SERIAL);
        while (1) { // 线性队列，保证了异步提交、同步执行
//            if (++index % 7 == 0) { // 外部递增
//                dispatch_async(sq, ^{ // 但是当提交到queue，得到处理时，index可能已经发生了变化，所以不正确
//                    NSLog(@"GCD producer :%d", index);
//                    [shareArray addObject:@(index)];
//                });
//            }
            dispatch_async(sq, ^{
                if (++index % 7 == 0) {
                    NSLog(@"GCD producer :%d", index);
                    [shareArray addObject:@(index)];
                }
            });
            dispatch_async(sq, ^{
                for (id object in shareArray) {
                    NSLog(@"GCD consumer :%@", object);
                }
                [shareArray removeAllObjects];
            });
        }
        
#elif kConcurrent
        // 如果是并发队列，则对可变对象需要加锁，否则就会遇到IO冲突
        // 适合顺序无关的生产消费
        dispatch_queue_t cq = dispatch_queue_create("cq.demo", DISPATCH_QUEUE_CONCURRENT);
        int cindex = 0;
        NSMutableArray *dataArray = [NSMutableArray array];
        while (1) {
            if (++cindex % 7 == 0) {// 生产的触发条件
                dispatch_async(cq, ^{
                    @synchronized (dataArray) {
                        NSLog(@"concurrent producer: %@", @(cindex));
                        [dataArray addObject:@(cindex)];
                    }
                });
            }
            
            
            dispatch_async(cq, ^{
                @synchronized (dataArray) {
                    for (id object in dataArray) {
                        NSLog(@"concurrent consumer: %@", object);
                    }
                    [dataArray removeAllObjects];
                }
            });
        }
#elif kPatchGroup
        NSLog(@"start aync task in group task");
        dispatch_group_t taskGrooup = dispatch_group_create();
        for (int i = 0; i < 100; ++i) {
            dispatch_group_enter(taskGrooup);
            dispatch_group_async(taskGrooup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"this is a block task end");
                dispatch_group_leave(taskGrooup);
            });
        }
        // 在group完成任务之后,通过block通知外部group中的任务完成，这个可以在不使用wait等待的时候，得到group的任务情况
        dispatch_group_notify(taskGrooup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"this is a notify block after group task end");
        });
        NSLog(@"aync task after group task");
        // 如果不等待，遇到程序结束，group中的全部task有的可能未执行
//        dispatch_group_wait(taskGrooup, DISPATCH_TIME_FOREVER);
#elif kWorkloop
        NSLog(@"start aync task in work loop");
        // 串行队列
//        dispatch_workloop_t wl = dispatch_workloop_create("my.workloop");
        dispatch_workloop_t wl = dispatch_workloop_create_inactive("my.workloop.inactive");
        dispatch_workloop_t wl1 = dispatch_workloop_create_inactive("my.workloop.inactive.1");
        
        //  必须是一个非激活的workloop，才可以配置此项目
        dispatch_workloop_set_autorelease_frequency(wl, DISPATCH_AUTORELEASE_FREQUENCY_NEVER);
        //  必须是一个非激活的workloop，才可以配置此项目
        dispatch_set_qos_class_floor(wl, QOS_CLASS_DEFAULT, -1);
        // 在非激活的workloop配置完成之后，需要激活，才能添加任务
        dispatch_activate(wl);
        
        //  必须是一个非激活的workloop，才可以配置此项目
        dispatch_set_qos_class_floor(wl1, QOS_CLASS_DEFAULT, -1000);
        dispatch_activate(wl1);
        
        dispatch_block_t wlbt1 = dispatch_block_create(0, ^{
            NSLog(@"wlbt 1");
        });
        dispatch_async(wl, wlbt1);
        dispatch_async(wl, ^{
            NSLog(@"wl 2");
        });
        dispatch_async(wl, ^{
            NSLog(@"wl 3");
        });
        dispatch_async(wl, ^{
            NSLog(@"wl 4");
        });
        
        dispatch_block_t wlt11= dispatch_block_create(0, ^{
            NSLog(@"wl11 1");
        });
        dispatch_async(wl1, wlt11);

#else
        
#endif
    }
    
    // 此步骤为了防止任务未被执行，程序已经退出了
    while (1) {
    }
    return 0;
}
