//
//  MTAObjectSerializerConfig.m
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

#import "MTAObjectSerializerConfig.h"
#import "MTAClassDescription.h"
#import "MTAEnumDescription.h"
#import "MTATypeDescription.h"

@implementation MTAObjectSerializerConfig {
	NSDictionary *_classes;
	NSDictionary *_enums;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		NSMutableDictionary *classDescriptions = [[NSMutableDictionary alloc] init];
		for (NSDictionary *d in dictionary[@"classes"]) {
			NSString *superclassName = d[@"superclass"];
			MTAClassDescription *superclassDescription = superclassName ? classDescriptions[superclassName] : nil;
			MTAClassDescription *classDescription = [[MTAClassDescription alloc] initWithSuperclassDescription:superclassDescription
																									dictionary:d];

			classDescriptions[classDescription.name] = classDescription;
		}

		NSMutableDictionary *enumDescriptions = [[NSMutableDictionary alloc] init];
		for (NSDictionary *d in dictionary[@"enums"]) {
			MTAEnumDescription *enumDescription = [[MTAEnumDescription alloc] initWithDictionary:d];
			enumDescriptions[enumDescription.name] = enumDescription;
		}

		_classes = [classDescriptions copy];
		_enums = [enumDescriptions copy];
	}

	return self;
}

- (NSArray *)classDescriptions {
	return [_classes allValues];
}

- (MTAEnumDescription *)enumWithName:(NSString *)name {
	return _enums[name];
}

- (MTAClassDescription *)classWithName:(NSString *)name {
	return _classes[name];
}

- (MTATypeDescription *)typeWithName:(NSString *)name {
	MTAEnumDescription *enumDescription = [self enumWithName:name];
	if (enumDescription) {
		return enumDescription;
	}

	MTAClassDescription *classDescription = [self classWithName:name];
	if (classDescription) {
		return classDescription;
	}

	return nil;
}

@end
