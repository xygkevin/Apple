//
//  main.m
//  test
//
//  Created by uwei on 2019/5/21.
//  Copyright © 2019 TEG of Tencent. All rights reserved.
//
#import <dlfcn.h>

#import <UIKit/UIKit.h>

#import "AppDelegate.h"



static __attribute__((destructor)) void afterMain() {
    printf(" afterMain \n");
}

int main(int argc, char * argv[])
{
    NSLog(@"main");
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
