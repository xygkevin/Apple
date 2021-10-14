//
//  MTAPasteboard.h
//  TA-SDK
//
//  Created by xiangchen on 13-12-16.
//  Copyright (c) 2013年 WQY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTKPasteboard : NSObject
+(void)set:(NSString *)key value:(NSString*) value;
+(NSString*)get:(NSString *)key;
+(NSString*)getCompanyDomain;
@end
