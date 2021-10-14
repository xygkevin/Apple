//
//  OCClass.m
//  SwiftSyntexDemo
//
//  Created by uwei on 10/11/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "OCClass.h"


#if !__has_feature(objc_arc)
#warning("this is need to ARC")
#endif

@implementation OCClass
- (void)showInfo:(NSString *)name {
    NSLog(@"%@", name);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
NSString * getInfo(const char *params) {
    return [NSString stringWithCString:params encoding:NSUTF8StringEncoding];
}
