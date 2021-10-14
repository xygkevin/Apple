//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by uwei on 6/8/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACStream.h>
#import <ReactiveObjC/RACReturnSignal.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // replace delegate
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //
        NSLog(@"send signal");
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            //
            NSLog(@"signal is destroyed");
        }];
    }];

    [signal subscribeNext:^(id x) {
        NSLog(@"1 - receive data is %@", x);
    }];

    [signal subscribeNext:^(id x) {
        NSLog(@"2 - receive data is %@", x);
    }];

    
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"first %@", x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"second %@", x);
    }];
    
    [subject sendNext:@2];
    [subject sendCompleted];
    
    
    // for datas of set
    NSArray *numbers = @[@1,@2,@3];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"---%@",x);
    }];
    
    NSDictionary *dict = @{@"name":@"uwei", @"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key = %@, value = %@", key, value);
    }];
    
    
    // for event
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"execute command %@", input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"Request Data"];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"command-----%@", x);
        }];
    }];
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"command-----%@", x);
    }];
    
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"ing");
        } else {
            NSLog(@"ed");
        }
    }];
    
    [command execute:@"1234556"];
    
    
    // for kvo
    RAC(self.label,  text) = self.text.rac_textSignal;
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [self.text.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"x ==== %@", x);
    }];
    
    
    // 当一个信号被多次订阅，避免多次调用创建信号中的block
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"Subscriber 1");
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"Subscriber 2");
    }];
    
    [connection connect];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"notification" object:nil] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
    }];
    
    // event
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //
        NSLog(@"event!");

        [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:@2333];

    }];
    
    [[self rac_signalForSelector:@selector(btnClicked:)] subscribeNext:^(id x) {
        NSLog(@"clicked!");
    }];
    
    [[self.btn rac_valuesAndChangesForKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        //
        NSLog(@"x = %@", x);
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"request"];
        return nil;
    }];
    
    // 应用场景：当依赖多个信号完成之后才执行逻辑
    [self rac_liftSelector:@selector(emptyMethodData1:d2:) withSignalsFromArray:@[signal, signal2]];
    
    
    // bind // 有一种应用场景，字典转模型
    [[self.text.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal * (id value, BOOL *stop) {
            return [RACReturnSignal return:value];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"bind %@", x);
    }];
    
    // 将信号映射成一个新的信号，flattenMap 比 map 更适合处理信号中包含信号
    [[self.text.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        //
        return [RACReturnSignal return:[NSString stringWithFormat:@"Output:%@", value]];
    }] subscribeNext:^(id  _Nullable x) {
         NSLog(@"flattenMap %@", x);
    }] ;
    

    [[self.text.rac_textSignal map:^id(id value) {
        return [NSString stringWithFormat:@"Output:%@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"map %@",x);
    }];
    
    
    //contact signal
    RACSignal *contactedSignals = [signal concat:signal2];
    [contactedSignals subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[signal then:^RACSignal *{
        return signal2;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    RACSignal *mergeSignal = [signal merge:signal2];
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    RACSignal *zipSignal = [signal zipWith:signal2];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    RACSignal *combineSignal = [signal combineLatestWith:signal2];
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    [[self.text.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length >3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);;
    }];
    
    [[self.text.rac_textSignal ignore:@"d"] subscribeNext:^(id x) {
        NSLog(@"ignore %@", x);
    }];
    
    [[self.text.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChanged %@", x);
    }];
    
    [[signal takeLast:1] subscribeNext:^(id x) {
        NSLog(@"takeLast %@", x);
    }];
    
    [[signal2 take:1] subscribeNext:^(id x) {
        NSLog(@"take %@", x);
    }];
    
    [self.text.rac_textSignal takeUntil:self.rac_willDeallocSignal];
    
}

- (void)emptyMethodData1:(id)data1 d2:(id)data2 {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"data1 = %@", data1);
    NSLog(@"data2 = %@", data2);
}

- (void)btnClicked:(UIButton *)sender {
    NSLog(@"custom button clicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
