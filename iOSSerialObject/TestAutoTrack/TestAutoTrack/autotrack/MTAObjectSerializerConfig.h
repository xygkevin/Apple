//
//  MTAObjectSerializerConfig.h
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

#import <Foundation/Foundation.h>

@class MTAEnumDescription;
@class MTAClassDescription;
@class MTATypeDescription;

@interface MTAObjectSerializerConfig : NSObject

@property (nonatomic, readonly) NSArray *classDescriptions;
@property (nonatomic, readonly) NSArray *enumDescriptions;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (MTATypeDescription *)typeWithName:(NSString *)name;
- (MTAEnumDescription *)enumWithName:(NSString *)name;
- (MTAClassDescription *)classWithName:(NSString *)name;

@end
