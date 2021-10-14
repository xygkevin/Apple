//
//  MTAObjectIdentityProvider.m
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

#import <libkern/OSAtomic.h>

#import "MTAObjectIdentityProvider.h"

@interface MTASequenceGenerator : NSObject

- (int32_t)nextValue;

@end

@implementation MTASequenceGenerator {
	int32_t _value;
}

- (instancetype)init {
	return [self initWithInitialValue:0];
}

- (instancetype)initWithInitialValue:(int32_t)initialValue {
	self = [super init];
	if (self) {
		_value = initialValue;
	}

	return self;
}

- (int32_t)nextValue {
	return OSAtomicAdd32(1, &_value);
}

@end

@implementation MTAObjectIdentityProvider {
	NSMapTable *_objectToIdentifierMap;
	MTASequenceGenerator *_sequenceGenerator;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_objectToIdentifierMap = [NSMapTable weakToStrongObjectsMapTable];
		_sequenceGenerator = [[MTASequenceGenerator alloc] init];
	}

	return self;
}

- (NSString *)identifierForObject:(id)object {
	if ([object isKindOfClass:[NSString class]]) {
		return object;
	}
	NSString *identifier = [_objectToIdentifierMap objectForKey:object];
	if (identifier == nil) {
		identifier = [NSString stringWithFormat:@"$%" PRIi32, [_sequenceGenerator nextValue]];
		[_objectToIdentifierMap setObject:identifier forKey:object];
	}

	return identifier;
}

@end
