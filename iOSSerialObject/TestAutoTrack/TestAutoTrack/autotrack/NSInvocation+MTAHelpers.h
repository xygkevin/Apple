//
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//
/// Copyright (c) 2014 Mixpanel. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSInvocation (MTAHelpers)

- (void)mta_setArgumentsFromArray:(NSArray *)argumentArray;
- (id)mta_returnValue;

@end
