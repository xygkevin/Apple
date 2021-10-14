//
//  TestObject.h
//  ObjectiveCSyntaxDemo
//
//  Created by uwei on 3/15/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject<NSCopying, NSMutableCopying, NSProgressReporting>

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger age;
@property (nonatomic, strong) NSUndoManager *undoManager;
@property (nonatomic, weak) id <NSProgressReporting>report;
@property (nonatomic, strong) NSBundleResourceRequest *resourceRequest;


/**
 atomic，表明对值类型是原子操作，即在其setter和getter中设置memory barrier
 保证了原子操作的顺序性，只是编译器尽量保证 【多线程读写】 的安全，实际并不是完全能保证
 但是对于 【只读】 或者是 【只写】 ，原子操作应该是可以保证其顺序，即多线程安全
 */
@property (atomic, assign) NSInteger threadIntNum;


- (void)method1:(NSString *)p1 __deprecated;
- (void)method2:(__unused NSString *)p1  __API_DEPRECATED("No longer supported", macos(10.4, 10.8));

- (void)changeName:(NSString *)name;

- (NSUserActivity *)addUserActivity;

- (void)notificationMethod;
- (void)startRequestResources;

@end
