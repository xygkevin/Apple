//
//  TestObject.m
//  ObjectiveCSyntaxDemo
//
//  Created by uwei on 3/15/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "TestObject.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation TestObject

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age {
    if (self = [super init]) {
        _age = age;
        _name = name;
        _undoManager = [[NSUndoManager alloc] init];
//        NSParameterAssert(age < 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
//    TestObject *copyObj = [[[self class] allocWithZone :zone] init];
//    copyObj.name = [self.name copy];
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    TestObject *obj = [[[self class] allocWithZone:zone] init];
    return obj;
}


- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)method1:(NSString *)p1 {
    NSLog(@"%@", p1);
    NSLog(@"test 1 :%@", [[self valueForKey:@"x"] stringValue]);
    NSLog(@"属性 %@", [[self class] jcePropertiesWithEncodedTypes]);
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendSynchronousRequest:[NSURLRequest new] returningResponse:nil error:nil];
//#pragma clang diagnostic pop
    
}

- (void)method2:(NSString *)p1 {
//    NSParameterAssert(p1);
    NSLog(@"%@", p1);
    _name = p1;
    
    [_undoManager registerUndoWithTarget:self selector:@selector(addUndoOperation) object:nil];
    [_undoManager setActionName:@"redo"];
}

+ (NSDictionary *)jcePropertiesWithEncodedTypes {
    NSMutableDictionary *theProps = [NSMutableDictionary dictionary];
    objc_property_t *propList = class_copyPropertyList([self class], nil);
    for (int i = 0; propList[i] != nil; i++) {
        objc_property_t oneProp = propList[i];
        NSString *propName = @(property_getName(oneProp));
        NSString *attrs = @(property_getAttributes(oneProp));
        if ([attrs rangeOfString:@",R,"].location == NSNotFound) {
            NSArray *attrParts = [attrs componentsSeparatedByString:@","];
            if (attrParts != nil && [attrParts count] > 0) {
                NSString *propType = [attrParts[0] substringFromIndex:1];
                theProps[propName] = propType;
            }
        }
    }
    free(propList);
    return theProps;
}

- (void)changeName:(NSString *)name {
    NSLog(@"%s", __FUNCTION__);
    [_undoManager registerUndoWithTarget:self selector:@selector(unchangeName:) object:self.name];
    [_undoManager setActionName:@"undo"];
    _name = name;
}

- (void)unchangeName:(NSString *)name {
    NSLog(@"%s", __FUNCTION__);
    [_undoManager registerUndoWithTarget:self selector:@selector(changeName:) object:self.name];
    [_undoManager setActionName:@"redo"];
    _name = name;
}

- (void)startTaskWithData:(NSData *)data {
    NSUInteger batchSize = 10;
    [self.report.progress setTotalUnitCount:10];
    
    for (NSUInteger index = 0; index < batchSize; index++) {
        // Check for cancellation
        if ([self.report.progress isCancelled]) {
            // Tidy up as necessary...
            break;
        }
        
        // Do something with this batch of data...
        
        // Report progress (add 1 because we've completed the work for the current index).
        [self.report.progress setCompletedUnitCount:(index + 1)];
    }
}

- (NSUserActivity *)addUserActivity {
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.tencent.uwei.openPage"];
    [userActivity setTitle:@"test"];
    [userActivity setKeywords:[NSSet setWithArray:@[@"uwei",@"yuan", @"fuck"]]];
    userActivity.eligibleForSearch = YES;
    userActivity.eligibleForHandoff = NO;
    userActivity.eligibleForPublicIndexing = YES;
    userActivity.referrerURL = [NSURL URLWithString:@"http://www.baidu.com"];
    [userActivity becomeCurrent];
    
    return userActivity;
}
- (void)notificationMethod {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)userDefaultsDidChange:(NSNotification *)notification {
    NSLog(@"%s, %@, %@", __FUNCTION__, notification.object, notification.userInfo);
}

- (void)startRequestResources {
    NSSet *resourcesTags = [NSSet setWithArray:@[@"test1", @"test2", @"test3"]];
     self.resourceRequest = [[NSBundleResourceRequest alloc] initWithTags:resourcesTags];
    [self.resourceRequest.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:@"observeResourcesTagsLoad"];
    
    [self.resourceRequest conditionallyBeginAccessingResourcesWithCompletionHandler:^(BOOL resourcesAvailable) {
        if (resourcesAvailable) {
            NSLog(@"resourcesAvailable");
            UIImage *image = [UIImage imageNamed:@"1" inBundle:self.resourceRequest.bundle compatibleWithTraitCollection:nil];
            if (image) {
                NSLog(@"conditionally  find 1");
            }
            [self.resourceRequest endAccessingResources];
        } else {
            // access from App Store
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.resourceRequest beginAccessingResourcesWithCompletionHandler:^(NSError * _Nullable error) {
                    NSLog(@"beginAccessing");
                    NSBundle *resourceBundle = self.resourceRequest.bundle;
                    UIImage *image = [UIImage imageNamed:@"1" inBundle:resourceBundle compatibleWithTraitCollection:nil];
                    if (image) {
                        NSLog(@"begin find 1");
                    }
                    [self.resourceRequest endAccessingResources];
                }];
            }];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.resourceRequest && [keyPath isEqualToString:@"fractionCompleted"]) {
        NSLog(@"resources load");
        
    }
}

@end
