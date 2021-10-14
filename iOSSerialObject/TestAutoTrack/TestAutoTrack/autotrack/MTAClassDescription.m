//
//  MTAClassDescription.m
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

#import "MTAClassDescription.h"
#import "MTAPropertyDescription.h"

@implementation MTADelegateInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		_selectorName = dictionary[@"selector"];
	}
	return self;
}

@end

@implementation MTAClassDescription {
	NSArray *_propertyDescriptions;
	NSArray *_delegateInfos;
}

- (instancetype)initWithSuperclassDescription:(MTAClassDescription *)superclassDescription
								   dictionary:(NSDictionary *)dictionary {
	self = [super initWithDictionary:dictionary];
	if (self) {
		_superclassDescription = superclassDescription;

		NSMutableArray *propertyDescriptions = [NSMutableArray array];
		for (NSDictionary *propertyDictionary in dictionary[@"properties"]) {
			[propertyDescriptions addObject:[[MTAPropertyDescription alloc] initWithDictionary:propertyDictionary]];
		}

		_propertyDescriptions = [propertyDescriptions copy];

		NSMutableArray *delegateInfos = [NSMutableArray array];
		for (NSDictionary *delegateInfoDictionary in dictionary[@"delegateImplements"]) {
			[delegateInfos addObject:[[MTADelegateInfo alloc] initWithDictionary:delegateInfoDictionary]];
		}
		_delegateInfos = [delegateInfos copy];
	}

	return self;
}

- (NSArray *)propertyDescriptions {
	NSMutableDictionary *allPropertyDescriptions = [[NSMutableDictionary alloc] init];

	MTAClassDescription *description = self;
	while (description) {
		for (MTAPropertyDescription *propertyDescription in description->_propertyDescriptions) {
			if (!allPropertyDescriptions[propertyDescription.name]) {
				allPropertyDescriptions[propertyDescription.name] = propertyDescription;
			}
		}
		description = description.superclassDescription;
	}

	return [allPropertyDescriptions allValues];
}

- (BOOL)isDescriptionForKindOfClass:(Class) class {
	return [self.name isEqualToString:NSStringFromClass(class)] && [self.superclassDescription isDescriptionForKindOfClass:[class superclass]];
}

	- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"<%@:%p name='%@' superclass='%@'>", NSStringFromClass([self class]), (__bridge void *)self, self.name, self.superclassDescription ? self.superclassDescription.name : @""];
}

@end
