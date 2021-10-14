//
//  ViewController.m
//  test
//
//  Created by uwei on 2019/5/21.
//  Copyright © 2019 TEG of Tencent. All rights reserved.
//

#import "ViewController.h"
#import "SMLagMonitor/SMCallTrace.h"
#import "QWLoadable.h"




__attribute__((objc_runtime_name("fuckU")))
@interface Student:NSObject
@property int age;

@end
@implementation Student
+(void)load {
    NSLog(@"%s", __func__);
    dispatch_async(dispatch_queue_create("test.uwei.q", NULL), ^{
        NSLog(@"DISPatch");
    });
    
}

- (void)test:(NSString *)x {
    NSLog(@"student %@", x);
}

+ (void)userDefinedLoad {
    NSLog(@"%s", __func__);
}


@end

QWLoadableFunctionBegin(Student)
[Student userDefinedLoad];
QWLoadableFunctionEnd(Student)
@interface Test :NSObject
+(void)hello;
@end
@implementation Test
+(void)hello{
    [SMCallTrace start];
    printf("hello\n");
    [self internal];
    
    //    NSString *str = [NSString stringWithUTF8String:"hi"];
    NSString *s = @"hi";
    NSLog(s);
    [SMCallTrace stop];
    [SMCallTrace save];
}

+(void)world{
    printf("world\n");
    
}

+(void)internal{
    
    printf("internal\n");
}

@end
@interface ViewController () {
    __block int v;
}

@property BOOL p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Test hello];
    [Test world];
    v = 10;
    self.p = NO;
}


@end
