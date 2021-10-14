//
//  XCTestDemoTests.m
//  XCTestDemoTests
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "TestAdvanceFunction.m"

@interface ObjectA : NSObject
- (void)pushNotification;
@property (strong, nonatomic) NSString *info;
@end

@implementation ObjectA

- (instancetype)init {
    if ([super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resovleNotification:) name:@"test.expectation.notificaion" object:nil];
    }
    return self;
}

- (void)resovleNotification:(NSNotification *)notification {
    for (int i = 0; i < 999999; ++i) {
    }
}

- (void)pushNotification {
    //  此处的第二个参数object 必须要与expectationForNotification:object:handler方法中的第二个参数属于同一个对象实例，否则将无法得到符合期望的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test.expectation.notificaion" object:self userInfo:@{@"key":@"value"}];
}

@end

@interface XCMyTestRun : XCTestRun
@end

@implementation XCMyTestRun

- (instancetype)initWithTest:(XCTest *)test {
    if ([super initWithTest:test]) {
    }
    return self;
}

- (void)start {
    [super start];
    NSLog(@"XCMyTestRun %@", NSStringFromSelector(_cmd));
    sleep(2);
}

- (void)stop {
    [super stop];
    NSLog(@"XCMyTestRun %@", NSStringFromSelector(_cmd));
}

@end

@interface XCMyTestCase : XCTestCase<XCTestObservation>
@property BOOL isFinished;
@end

@implementation XCMyTestCase

+ (Class)testRunClass {
    return [XCMyTestRun class];
}

// 在每一个test方法开始前，自定义条件
//- (void)setUp {
// 在整个case包含的test方法开始前，自定义条件
+ (void)setUp {
    [super setUp];
    NSLog(@"===========start============");
//    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
}

// 在每一个test方法结束后，清理工作区
//- (void)tearDown {
// 在整个case包含的test方法全部结束之后，清理工作区
+ (void)tearDown {
    [super tearDown];
    NSLog(@"===========finish============");
}

- (void)testMyMethod0 {
    NSLog(@"%s before", __FUNCTION__);
    // 在方法执行结束以后，执行block，类型将tearDown方法声明为实例方法
    [self addTeardownBlock:^{
        NSLog(@"addTeardownBlock0");
    }];
    NSLog(@"%s after", __FUNCTION__);
}

- (void)testMyMethod1 {
    NSLog(@"%s", __FUNCTION__);
    NSObject *obj = nil;
//    XCTAssertNotNil(obj, "obj is nil");
}

#pragma mark - Measuring Performance
- (void)testPerformance0 {
    NSLog(@"%s", __FUNCTION__);
    // 以s级来衡量block的执行时间
    [self measureBlock:^{
        NSMutableString *string = [NSMutableString new];
        for (int i = 0; i < 99999; ++i) {
            [string appendFormat:@"%d", i];
        }
    }];
}

- (void)testPerformance1 {
    NSLog(@"%s", __FUNCTION__);
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        NSMutableString *string = [NSMutableString new];
        for (int i = 0; i < 99999; ++i) {
            if (i == 9999) {
                // 只能在block中调用一次，且需要在第二个参数为NO的条件下
                [self startMeasuring];
            }
            // 只能在block中调用一次
            if (i == 88888) {
                [self stopMeasuring];
            }
            [string appendFormat:@"%d", i];
        }
    }];
}

// 更改measure系列方法的维度参数
+ (NSArray <XCTPerformanceMetric> *)defaultPerformanceMetrics {
    // 目前就一个wallClockTime
    return @[XCTPerformanceMetric_WallClockTime];
}

#pragma mark - Testing Asynchronous Operations with Expectations
- (void)testExpectationDescription {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Download apple.com home page"];
    NSURL *url = [NSURL URLWithString:@"https://apple.com"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertNotNil(data, "No data was downloaded.");
        [expectation fulfill];
    }] resume];
    [self waitForExpectations:@[expectation] timeout:10.0];
}


- (void)testExpectaionNotification {
    ObjectA *objA = [[ObjectA alloc] init];
    __block NSString *value = nil;
    //    XCTNSNotificationExpectation *notificationExpectation = [[XCTNSNotificationExpectation alloc] initWithName:@"test.expectation.notificaion"];
    XCTestExpectation *expectation = [self expectationForNotification:@"test.expectation.notificaion" object:objA handler:^BOOL(NSNotification * _Nonnull notification) {
        if (notification.userInfo[@"key"]) {
            value = notification.userInfo[@"key"];
        } else {
            value = nil;
        }
        // 不能再此处调用
//        [expectation fulfill];
        
        return (value != nil);
    }];
    
    // 此处相当于任意地方触发ObjectA实例post出通知，类似按钮点击，网络交互完成等，发出通知
    [objA pushNotification];
    // 同上
    // 此处的第二个参数object 必须要与expectationForNotification:object:handler方法中的第二个参数属于同一个对象实例，否则将无法得到符合期望的通知
    //    ObjectA *objB = [[ObjectA alloc] init]; // 如果使用objB则会超时
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"test.expectation.notificaion" object:objA userInfo:@{@"key":@"value"}];
    [self waitInfoOfExpectation:expectation];
    NSLog(@"%@", value);
    XCTAssertNotNil(value, "value is nil");
}

- (void)testExpectationPredicate {
    NSString *value = @"value";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == 'value'", value];
    XCTestExpectation *expectation = [self expectationForPredicate:predicate evaluatedWithObject:value handler:^BOOL{
        return YES;
    }];
    // 此处赋值时机不对，因为predicate 已经执行完毕
    //    value = @"value";
    [self waitInfoOfExpectation:expectation];
}

- (void)testExpectationKVO1 {
    ObjectA *objA = [[ObjectA alloc] init];
    // 此处时机不正确，因为是KVO且是有isEqual的比较，不能提前赋值；另外， Swift中，KVO的属性需要声明为dynamic
    //    objA.info = @"test";
    // 因为是KVO，所以，此处的实现是将keypath添加到observe中，后续赋值的时候，将会执行KVO
    XCTestExpectation *expectation = [self keyValueObservingExpectationForObject:objA keyPath:@"info" expectedValue:@"test"];
    objA.info = @"test";
    [self waitInfoOfExpectation:expectation];
}
- (void)testExpectationKVO2 {
    ObjectA *objA = [[ObjectA alloc] init];
    objA.info = @"a";
    // 因为是KVO，所以，此处的实现是将keypath添加到observe中，后续赋值的时候，将会执行KVO
    // 此处之后的每一次对info属性赋值都会调用handler回调
    XCTestExpectation *expectation = [self keyValueObservingExpectationForObject:objA keyPath:@"info" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        NSLog(@"%@", change);
        if ([change[@"new"] isEqual:change[@"old"]]) {
            NSLog(@"not change!");
            return NO;
        } else {
            NSLog(@"change!");
            return YES;
        }
    }];
    objA.info = @"a";
    objA.info = @"b";
    [self waitInfoOfExpectation:expectation];
}

#pragma mark - Creating Tests Programmatically
- (void)testTestProgrammatically {
    NSLog(@"%s", __FUNCTION__);
    // 可以在运行时调用Case中自定义的方法，同样提供NSInvocation实例参数的方法
    XCMyTestCase *testCase = [[XCMyTestCase alloc] initWithSelector:@selector(runtimeMethod)];
    [testCase invokeTest];
}
- (void)runtimeMethod {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // 查询 Test Case 中全部带有test前缀的自定义方法
    NSLog(@"%@", [[XCMyTestCase defaultTestSuite] tests]);
}

- (void)waitInfoOfExpectation:(XCTestExpectation *)expectation {
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5.0];
    NSString *resultDescription = nil;
    switch (result) {
        case XCTWaiterResultTimedOut:
            resultDescription = @"TimeOut";
            break;
        case XCTWaiterResultCompleted:
            resultDescription = @"Completed";
            break;
        case XCTWaiterResultInterrupted:
            resultDescription = @"Interrupted";
            break;
        case XCTWaiterResultIncorrectOrder:
            resultDescription = @"IncorrectOrder";
            break;
        case XCTWaiterResultInvertedFulfillment:
            resultDescription = @"InvertedFilfillment";
            break;
            
        default:
            break;
    }
    NSLog(@"%@ status = %@", NSStringFromClass([expectation class]), resultDescription);
}

// 监控 Test Case 执行情况
#pragma mark - XCTestObservation
- (void)testCaseWillStart:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testCaseDidFinish:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface XCTestDemoTests : XCTestCase {
    
@private
    ViewController *vc;
    
}
@end

@implementation XCTestDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

#pragma mark - Test Suite
// 根据已知 test case，构造自定义的 test suite，并执行 test case 中的自定义方法
- (void)testCustomSuite {
//    XCTestSuite *customSuite = [XCTestSuite testSuiteForTestCaseClass:[XCMyTestCase class]]; // ok
//    XCTestSuite *customSuite = [XCTestSuite testSuiteForTestCaseWithName:@"XCMyTestCase"]; //ok
    
    //    NSString *bPath = [[NSBundle mainBundle] bundlePath];
    //    XCTestSuite *testSuite = [XCTestSuite testSuiteForBundlePath:bPath]; // not working
    
    XCTestSuite *customSuite = [[XCTestSuite alloc] initWithName:@"CustomSuite"];
    XCMyTestCase *testCase = [[XCMyTestCase alloc] initWithSelector:@selector(runtimeMethod)];
    
    // 这个方式可以从测试文件中加载测试case，然后执行。
//    XCTestSuite *customSuite = [TestAdvanceFunction defaultTestSuite];
//    TestAdvanceFunction *testCase = [[TestAdvanceFunction alloc] initWithSelector:@selector(runtimeMethod)];
    [customSuite addTest:testCase];
    for (XCTest *test in customSuite.tests) {
        // XCTestRun 用来收集信息， start or stop，用来自定义testRun的执行，不会执行 test case，如果没有特定需求，不需要调用
        // 系统 TestRun
//        XCTestRun *testRun = [XCTestRun testRunWithTest:test];
        // 自定义TestRun 需要注意 TestCase 类中的雷属性 testRunClass 的返回x类型
        XCMyTestRun *testRun = [XCMyTestRun testRunWithTest:test];
        // 执行case
         [test performTest:testRun];
        NSLog(@"%@", testRun.hasSucceeded ? @"success":@"failed");
        NSLog(@"%@   %@",  testRun.startDate, testRun.stopDate);
    }
}

- (void)testMethod {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testA {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testZ {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testBundle {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:file];
    // XCAssert是一系列可用的断言宏
    XCTAssertNotNil(data);
    XCTAssertNil([data objectForKey:@"key"]);
    NSLog(@"[Test] bundle data: %@", data);
}

@end
