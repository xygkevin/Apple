//
//  MTAApplicationStateSerializer.m
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

#import "MTAApplicationStateSerializer.h"
#import "MTAClassDescription.h"
#import "MTAObjectIdentityProvider.h"
#import "MTAObjectSerializer.h"
#import "MTAObjectSerializerConfig.h"
#import <QuartzCore/QuartzCore.h>

@implementation MTAApplicationStateSerializer {
	MTAObjectSerializer *_serializer;
	UIApplication *_application;
}

- (instancetype)initWithApplication:(UIApplication *)application
					  configuration:(MTAObjectSerializerConfig *)configuration
			 objectIdentityProvider:(MTAObjectIdentityProvider *)objectIdentityProvider {
	NSParameterAssert(application != nil);
	NSParameterAssert(configuration != nil);

	self = [super init];
	if (self) {
		_application = application;
		_serializer = [[MTAObjectSerializer alloc] initWithConfiguration:configuration objectIdentityProvider:objectIdentityProvider];
	}

	return self;
}

- (UIImage *)screenshotImageForWindow:(UIWindow *)window {
	UIImage *image = nil;

	UIWindow *mainWindow = [self uiMainWindow:window];
	if (mainWindow && !CGRectEqualToRect(mainWindow.frame, CGRectZero)) {
		UIGraphicsBeginImageContextWithOptions(mainWindow.bounds.size, YES, mainWindow.screen.scale);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		if ([mainWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
			if ([mainWindow drawViewHierarchyInRect:mainWindow.bounds afterScreenUpdates:NO] == NO) {
				//                MTAError(@"Unable to get complete screenshot for window at index: %d.", (int)index);
			}
		} else {
			[mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
		}
#else
		[mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
#endif
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}

	return image;
}

- (UIWindow *)uiMainWindow:(UIWindow *)window {
	if (window != nil) {
		return window;
	}
	return _application.windows[0];
}

- (NSDictionary *)objectHierarchyForWindow:(UIWindow *)window {
	UIWindow *mainWindow = [self uiMainWindow:window];
	if (mainWindow) {
		return [_serializer serializedObjectsWithRootObject:mainWindow];
	}

	return @{};
}

- (NSDictionary *)objectHierarchyForVC:(UIResponder *)window {
    if (window) {
        return [_serializer serializedObjectsWithRootObject:window];
    }
    
    return @{};
}

@end
