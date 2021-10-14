//
//  MTAUITableViewBinding.m
//  SensorsAnalyticsSDK
//
//	Created by tyzual on 9/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/20/16
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//
///  Created by Amanda Canyon on 8/5/14.
///  Copyright (c) 2014 Mixpanel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//#import "MTALogger.h"
#import "MTASwizzler.h"
#import "MTAUITableViewBinding.h"

@implementation MTAUITableViewBinding

+ (NSString *)typeName {
	return @"UITableView";
}

+ (MTAEventBinding *)bindingWithJSONObject:(NSDictionary *)object {
	NSString *path = object[@"path"];
	if (![path isKindOfClass:[NSString class]] || [path length] < 1) {
		//        MTAError(@"must supply a view path to bind by");
		return nil;
	}

	NSString *eventId = object[@"event_id"];
	if (![eventId isKindOfClass:[NSString class]] || [eventId length] < 1) {
		//        MTAError(@"binding requires an event name");
		return nil;
	}

	NSInteger triggerId = [[object objectForKey:@"trigger_id"] integerValue];
	if (triggerId <= 0) {
		//        MTAError(@"binding requires a trigger id");
	}
	BOOL deployed = [[object objectForKey:@"deployed"] boolValue];

	NSString *tableDelegateName = object[@"table_delegate"];
	Class tableDelegate = NSClassFromString(tableDelegateName);
	if (!tableDelegate) {
		//        MTAError(@"binding requires a table_delegate class, path='%@', trigger_id='%ld', event_name='%@', delegate='%@'",
		//                path, triggerId, eventName, tableDelegateName ? tableDelegateName : @"Unset");
		return nil;
	}

	return [[MTAUITableViewBinding alloc] initWithEventId:eventId
											 andTriggerId:triggerId
												   onPath:path
											   isDeployed:deployed
											 withDelegate:tableDelegate];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
+ (MTAEventBinding *)bindngWithJSONObject:(NSDictionary *)object {
	return [self bindingWithJSONObject:object];
}
#pragma clang diagnostic pop

- (instancetype)initWithEventId:(NSString *)eventId
				   andTriggerId:(NSInteger)triggerId
						 onPath:(NSString *)path
					 isDeployed:(BOOL)deployed
				   withDelegate:(Class)delegateClass {
	if (self = [super initWithEventId:eventId andTriggerId:triggerId onPath:path isDeployed:deployed]) {
		[self setSwizzleClass:delegateClass];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"UITableView Event Tracking: '%@' for '%@'", [self eventId], [self path]];
}


#pragma mark-- Executing Actions

- (void)execute {
	if (!self.running && self.swizzleClass != nil) {
		void (^block)(id, SEL, id, id) = ^(id view, SEL command, UITableView *tableView, NSIndexPath *indexPath) {
			NSObject *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
			// select targets based off path
			if (tableView && [self.path isLeafSelected:tableView fromRoot:root]) {
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
				NSString *label = (cell && cell.textLabel && cell.textLabel.text) ? cell.textLabel.text : @"";
				NSDictionary *properties = @{
					@"$vtrack_cell_index": [NSString stringWithFormat:@"%ld", (unsigned long)indexPath.row],
					@"$vtrack_cell_section": [NSString stringWithFormat:@"%ld", (unsigned long)indexPath.section],
					@"$vtrack_cell_label": label
				};
				[self track:[self eventId] withProperties:properties];
			}
		};

		[MTASwizzler swizzleSelector:@selector(tableView:didSelectRowAtIndexPath:)
							 onClass:self.swizzleClass
						   withBlock:block
							   named:self.name];
		self.running = true;
	}
}

- (void)stop {
	if (self.running && self.swizzleClass != nil) {
		[MTASwizzler unswizzleSelector:@selector(tableView:didSelectRowAtIndexPath:)
							   onClass:self.swizzleClass
								 named:self.name];
		self.running = false;
	}
}

#pragma mark-- Helper Methods

- (UITableView *)parentTableView:(UIView *)cell {
	// iterate up the view hierarchy to find the table containing this cell/view
	UIView *aView = cell.superview;
	while (aView != nil) {
		if ([aView isKindOfClass:[UITableView class]]) {
			return (UITableView *)aView;
		}
		aView = aView.superview;
	}
	return nil; // this view is not within a tableView
}

#pragma mark-- NSCoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setSwizzleClass:NSClassFromString([aDecoder decodeObjectForKey:@"table_delegate"])];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:NSStringFromClass(self.swizzleClass) forKey:@"table_delegate"];
}

@end
