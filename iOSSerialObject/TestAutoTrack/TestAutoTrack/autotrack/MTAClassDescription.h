//
//  MTAClassDescription.h
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

@interface MTAClassDescription : MTATypeDescription

@property (nonatomic, readonly) MTAClassDescription *superclassDescription;
@property (nonatomic, readonly) NSArray *propertyDescriptions;
@property (nonatomic, readonly) NSArray *delegateInfos;

- (instancetype)initWithSuperclassDescription:(MTAClassDescription *)superclassDescription dictionary:(NSDictionary *)dictionary;

- (BOOL)isDescriptionForKindOfClass:(Class) class;

@end

@interface MTADelegateInfo : NSObject

@property (nonatomic, readonly) NSString *selectorName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
