//
//  MTADesignerEventBindingMessage.m
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

#import "MTADesignerEventBindingMessage.h"
#import "MTAEventBinding.h"
#import "MTAObjectSelector.h"
#import "MTASwizzler.h"

#pragma mark-- MTAEventBindingCollection

@implementation MTAEventBindingCollection

+ (instancetype)sharedInstance {
	static MTAEventBindingCollection *_instance;
	static dispatch_once_t _onceFlag;
	dispatch_once(&_onceFlag, ^{
		_instance = [[MTAEventBindingCollection alloc] init];
	});
	return _instance;
}

- (void)updateBindingsWithPayload:(NSArray *)bindingPayload {
	NSMutableSet *newBindings = [[NSMutableSet alloc] init];
	for (NSDictionary *bindingInfo in bindingPayload) {
		MTAEventBinding *binding = [MTAEventBinding bindingWithJSONObject:bindingInfo];
		if (binding != nil) {
			[newBindings addObject:binding];
		}
	}

	[self updateBindingsWithEvents:newBindings];
}

- (void)updateBindingsWithEvents:(NSSet *)newBindings {
	[self cleanup];

	self.bindings = [newBindings mutableCopy];
	for (MTAEventBinding *newBinding in self.bindings) {
		if ([newBinding isKindOfClass:[MTAEventBinding class]]) {
			[newBinding execute];
		}
	}
}

- (void)cleanup {
	if (self.bindings) {
		for (MTAEventBinding *oldBinding in self.bindings) {
			if ([oldBinding isKindOfClass:[MTAEventBinding class]]) {
				[oldBinding stop];
			}
		}
	}
	self.bindings = nil;
}

@end
