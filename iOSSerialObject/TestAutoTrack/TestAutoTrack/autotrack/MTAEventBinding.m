//
//  MTAEventBinding.m
//  SensorsAnalyticsSDK
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/20/16
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//

#import "MTAEventBinding.h"
#import "MTAUIControlBinding.h"
#import "MTAUITableViewBinding.h"

@implementation MTAEventBinding

+ (MTAEventBinding *)bindingWithJSONObject:(NSDictionary *)object {
	if (object == nil) {
		//        MTAError(@"must supply an JSON object to initialize from");
		return nil;
	}

	NSString *bindingType = object[@"event_type"];
	Class klass = [self subclassFromString:bindingType];
	return [klass bindingWithJSONObject:object];
}

+ (Class)subclassFromString:(NSString *)bindingType {
	NSDictionary *classTypeMap = @{
			[MTAUIControlBinding typeName]: [MTAUIControlBinding class],
			[MTAUITableViewBinding typeName]: [MTAUITableViewBinding class]
	};
	return [classTypeMap valueForKey:bindingType] ?: [MTAUIControlBinding class];
}

- (instancetype)initWithEventId:(NSString *)eventId
				   andTriggerId:(NSInteger)triggerId
						 onPath:(NSString *)path
					 isDeployed:(BOOL)deployed {
	if (self = [super init]) {
		self.triggerId = triggerId;
		self.deployed = deployed;
		self.eventId = eventId;
		self.path = [[MTAObjectSelector alloc] initWithString:path];
		self.name = [[NSUUID UUID] UUIDString];
		self.running = NO;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Event Binding base class: '%@' for '%@'", [self eventId], [self path]];
}

#pragma mark-- Method stubs

+ (NSString *)typeName {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (void)execute {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

- (void)stop {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
								 userInfo:nil];
}

#pragma mark-- NSCoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	NSInteger triggerId = [aDecoder decodeIntegerForKey:@"triggerId"];
	BOOL deployed = [aDecoder decodeBoolForKey:@"deployed"];
	NSString *path = [aDecoder decodeObjectForKey:@"path"];
	NSString *eventId = [aDecoder decodeObjectForKey:@"eventId"];
	if (self = [self initWithEventId:eventId andTriggerId:triggerId onPath:path isDeployed:deployed]) {
		self.name = [aDecoder decodeObjectForKey:@"name"];
		self.swizzleClass = NSClassFromString([aDecoder decodeObjectForKey:@"swizzleClass"]);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInteger:_triggerId forKey:@"triggerId"];
	[aCoder encodeBool:_deployed forKey:@"deployed"];
	[aCoder encodeObject:_name forKey:@"name"];
	[aCoder encodeObject:_path.string forKey:@"path"];
	[aCoder encodeObject:_eventId forKey:@"eventId"];
	[aCoder encodeObject:NSStringFromClass(_swizzleClass) forKey:@"swizzleClass"];
}

@end
