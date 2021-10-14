//
//  MTADesignerEventBindingMessage.h
//  SensorMTAnalyticsSDK
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/18/16.
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//
///  Created by Amanda Canyon on 11/18/14.
///  Copyright (c) 2014 Mixpanel. All rights reserved.
//

#import "MTADesignerSessionCollection.h"

#pragma mark-- EventBinding Collection

@interface MTAEventBindingCollection : NSObject <MTADesignerSessionCollection>

@property (nonatomic) NSMutableSet *bindings;

+ (instancetype)sharedInstance;

- (void)updateBindingsWithPayload:(NSArray *)bindingPayload;
- (void)updateBindingsWithEvents:(NSSet *)newBindings;
- (void)cleanup;

@end
