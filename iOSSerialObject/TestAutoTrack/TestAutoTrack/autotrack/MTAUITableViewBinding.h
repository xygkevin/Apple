//
//  MTAUITableViewBinding.h
//  SensorsAnalyticsSDK
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/20/16
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//

#import "MTAEventBinding.h"

@interface MTAUITableViewBinding : MTAEventBinding

- (instancetype)init __unavailable;
- (instancetype)initWithEventId:(NSString *)eventId
				   andTriggerId:(NSInteger)triggerId
						 onPath:(NSString *)path
					 isDeployed:(BOOL)deployed
				   withDelegate:(Class)delegateClass;

@end
