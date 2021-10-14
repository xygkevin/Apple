//
//  TestAdvanceFunction.m
//  XCTestDemo
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestAdvanceFunction : XCTestCase

@end

@implementation TestAdvanceFunction

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testM1 {
    sleep(1);
    NSLog(@"TestM1");
}

- (void)testM2 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)runtimeMethod {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)testCaseWillStart:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testCaseDidFinish:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

@end
