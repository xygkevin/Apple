//
//  main.m
//  MemoryCache
//
//  Created by uwei on 2019/5/16.
//  Copyright © 2019 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDiscardable : NSObject <NSDiscardableContent>

@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSArray <NSString *> *info;

@end

@implementation DataDiscardable

- (BOOL)beginContentAccess {
    NSLog(@"%s", __func__);
    NSPredicate *predicate = [NSPredicate predicateWithValue:self.age.integerValue > 2];
    return [predicate evaluateWithObject:self];
}

- (void)endContentAccess {
     NSLog(@"%s", __func__);
}

- (void)discardContentIfPossible {
     NSLog(@"%s", __func__);
}

- (BOOL)isContentDiscarded {
    NSLog(@"%s", __func__);
    NSPredicate *predicate = [NSPredicate predicateWithValue:self.age.integerValue <= 2];
    return [predicate evaluateWithObject:self];
}

@end




@interface MemoryCache : NSObject <NSCacheDelegate>

@property (strong, nonatomic, class, readonly) NSCache *memCache;

@end



@implementation MemoryCache

+ (instancetype)instance {
    static MemoryCache *memC;
    if (!memC) {
        memC = [[self alloc] init];
    }
    return memC;
}

static NSCache *c;
+ (NSCache *)memCache {
    if (!c) {
        c = [[NSCache alloc] init];
    }
    c.name = @"HiCache";
    c.countLimit = 2;
    c.delegate = [MemoryCache instance];
    return c;
}

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    if ([obj isKindOfClass:[DataDiscardable class]]) {
         NSLog(@"%s:%@", __func__,((DataDiscardable*)obj).age);
    } else {
        NSLog(@"%s:%@", __func__,obj);
    }
    
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        for (int i = 0; i < [MemoryCache memCache].countLimit + 2; ++i) {
            DataDiscardable *d = [DataDiscardable new];
            d.age = @(i);
            d.info = @[[NSString stringWithFormat:@"key%d", i]];
            [[MemoryCache memCache] setObject:d forKey:[NSString stringWithFormat:@"key%d", i]];
        }
        
        for (int i = 0; i < [MemoryCache memCache].countLimit + 2; ++i) {
            /*
             当访问可删除对象时，NSCache会根据对象中实现的NSDiscardableContenty协议，去判断是不是要丢弃还是返回结果
             由于limit是2，对于本例中的0，1，2，3中的前两个对象会被直接释放，但是对于index是2的的情况，就需要执行以下逻辑：
             * - 先调用isContentDiscarded看看是不是可以删除
             * - 再，如果可以删除，则调用cache:willEvictObject:去删除
             * - 最后，数据对象需要实现discardContentIfPossible去释放资源
             -[DataDiscardable isContentDiscarded]
             -[MemoryCache cache:willEvictObject:]:2
             -[DataDiscardable discardContentIfPossible]
             */
            NSLog(@"%@", ((DataDiscardable *)([[MemoryCache memCache] objectForKey:[NSString stringWithFormat:@"key%d", i]])).age);
        }
        
    }
    return 0;
}
