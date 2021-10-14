//
//  MTAEnumDescription.h
//  SensorsAnalyticsSDK
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/18/16.
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//
/// Copyright (c) 2014 Mixpanel. All rights reserved.
//

#import "MTATypeDescription.h"
#import <Foundation/Foundation.h>

@interface MTAEnumDescription : MTATypeDescription

@property (nonatomic, assign, getter=isFlagsSet, readonly) BOOL flagSet;
@property (nonatomic, copy, readonly) NSString *baseType;

- (NSArray *)allValues; // array of NSNumber instances

@end
