//
//  MTAObjectSerializerContext.m
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

#import "MTAObjectSerializerContext.h"

@implementation MTAObjectSerializerContext {
	NSMutableSet *_visitedObjects;
	NSMutableSet *_unvisitedObjects;
	NSMutableDictionary *_serializedObjects;
}

- (instancetype)initWithRootObject:(id)object {
	self = [super init];
	if (self) {
		_visitedObjects = [NSMutableSet set];
		_unvisitedObjects = [NSMutableSet setWithObject:object];
		_serializedObjects = [[NSMutableDictionary alloc] init];
	}

	return self;
}

- (BOOL)hasUnvisitedObjects {
	return [_unvisitedObjects count] > 0;
}

- (void)enqueueUnvisitedObject:(NSObject *)object {
	NSParameterAssert(object != nil);

	[_unvisitedObjects addObject:object];
}

- (NSObject *)dequeueUnvisitedObject {
	NSObject *object = [_unvisitedObjects anyObject];
	[_unvisitedObjects removeObject:object];

	return object;
}

- (void)addVisitedObject:(NSObject *)object {
	NSParameterAssert(object != nil);

	[_visitedObjects addObject:object];
}

- (BOOL)isVisitedObject:(NSObject *)object {
	return object && [_visitedObjects containsObject:object];
}

- (void)addSerializedObject:(NSDictionary *)serializedObject {
	NSParameterAssert(serializedObject[@"id"] != nil);
	_serializedObjects[serializedObject[@"id"]] = serializedObject;
}

- (NSArray *)allSerializedObjects {
	return [_serializedObjects allValues];
}

@end
