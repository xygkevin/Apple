//
//  OCClass.h
//  SwiftSyntexDemo
//
//  Created by uwei on 10/11/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
     EnumDemoX = 0,
     EnumDemoY = 1
}ENUMDEMO;

@interface OCClass : NSObject

- (void)showInfo:(NSString *)name NS_SWIFT_NAME(info(name:));

@end

NSString * getInfo(const char *params) NS_SWIFT_NAME(showInfo(params:));
