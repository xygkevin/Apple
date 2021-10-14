//
//  main.m
//  OCClassTemplate
//
//  Created by uweiyuan on 2020/5/9.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>



@protocol Template1Delegate <NSObject>
@optional
- (void)doSomething;

@end

@protocol Template2Delegate <NSObject>
@optional
- (void)doSomething;
@end

//@interface Class1T : NSObject<Template1Delegate>
//
//@end
//
//@implementation Class1T
//
//- (void)doSomething {
//    NSLog(@"do T1");
//}
//
//@end
//
//@interface Class2T : NSObject<Template2Delegate>
//
//@end
//
//@implementation Class2T
//
//- (void)doSomething {
//    NSLog(@"do T2");
//}
//
//@end

//@interface ClassTemplate : NSObject<Template1Delegate, Template2Delegate>
//
//@end
//@implementation ClassTemplate
//
//- (instancetype)init {
//    if ([[self class] conformsToProtocol:@protocol(Template1Delegate)]) {
//        object_setClass(self, [Class1T class]);
//    }
//
//    if ([[self class] conformsToProtocol:@protocol(Template2Delegate)]) {
//        object_setClass(self, [Class2T class]);
//    }
//
//    return self;
//}
//
//@end

@protocol ClassTemplateDelegate <NSObject>

- (void)doSomething;

@end

@interface Class1T : NSObject<ClassTemplateDelegate>
@end

@implementation Class1T

- (void)doSomething {
    NSLog(@"do T1");
}

@end

@interface Class2T : NSObject<ClassTemplateDelegate>
@end

@implementation Class2T

- (void)doSomething {
    NSLog(@"do T2");
}

@end


@interface ClassTemplate < __covariant T: id<ClassTemplateDelegate> > : NSObject
@property (nonatomic, strong) T t;
- (void)doSomething;
@end
@implementation ClassTemplate
- (void)doSomething {
    [self.t doSomething];
}
@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //        ClassTemplate <Template1Delegate> * c1 = [[ClassTemplate alloc] init];
        //        [c1 doSomething];
        //
        //        ClassTemplate <Template2Delegate> * c2 = [[ClassTemplate alloc] init];
        //        [c2 doSomething];
        
        ClassTemplate <Class1T *> *c1 = [[ClassTemplate alloc] init];
        c1.t = [Class1T new];
        [c1 doSomething];
        
        ClassTemplate <Class2T *> *c2 = [[ClassTemplate alloc] init];
        c2.t = [Class2T new];
        [c2 doSomething];
        
    }
    return 0;
}
