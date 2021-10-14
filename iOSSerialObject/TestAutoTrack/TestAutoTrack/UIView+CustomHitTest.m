//
//  UIView+CustomHitTest.m
//  TestAutoTrack
//
//  Created by uwei on 16/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "UIView+CustomHitTest.h"
#import <objc/runtime.h>

@implementation UIWindow (CustomHitTest)
+ (void)hook {
    SEL origAppear = @selector(hitTest:withEvent:);
    SEL hookAppear = @selector(custom_hook_HitTest:withEvent:);
    
    [UIWindow swizzleMethods:[self class] originalSelector:origAppear swizzledSelector:hookAppear];
}

+ (void)swizzleMethods:(Class) class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

- (UIView *)custom_hook_HitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"your point is (%f, %f) and view is %@", point.x, point.y, event.allTouches.anyObject.view);
    
//    UITouch *touchInWindow = [event touchesForWindow:[[UIApplication sharedApplication] keyWindow]].anyObject;
//    CGPoint pointInWindow  = [touchInWindow locationInView:nil];
//    NSLog(@"In window your point is (%f, %f)", pointInWindow.x, pointInWindow.y);
    
    return [self custom_hook_HitTest:point withEvent:event];
}


@end
