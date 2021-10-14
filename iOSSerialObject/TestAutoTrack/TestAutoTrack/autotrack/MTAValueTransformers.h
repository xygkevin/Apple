//
//  MTAValueTransformers.h
//  SensorsAnalyticsSDK
//
//	Created by tyzual on 15/3/2017
//	Copyright (c) 2017 Tencent. All rights reserved.
//
//  Created by 雨晗 on 1/20/16
//  Copyright (c) 2016年 SensorsData. All rights reserved.
//
///  Created by Alex Hofsteede on 5/5/14.
///  Copyright (c) 2014 Mixpanel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAPassThroughValueTransformer : NSValueTransformer

@end

@interface MTABOOLToNSNumberValueTransformer : NSValueTransformer

@end

@interface MTACATransform3DToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTACGAffineTransformToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTACGColorRefToNSStringValueTransformer : NSValueTransformer

@end

@interface MTACGPointToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTACGRectToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTACGSizeToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTANMTAttributedStringToNSDictionaryValueTransformer : NSValueTransformer

@end

@interface MTANSNumberToCGFloatValueTransformer : NSValueTransformer

@end

__unused static id transformValue(id value, NSString *toType) {
	assert(value != nil);

	if ([value isKindOfClass:[NSClassFromString(toType) class]]) {
		return [[NSValueTransformer valueTransformerForName:@"MTAPassThroughValueTransformer"] transformedValue:value];
	}

	NSString *fromType = nil;
	NSArray *validTypes = @[[NSString class], [NSNumber class], [NSDictionary class], [NSArray class], [NSNull class]];
	for (Class c in validTypes) {
		if ([value isKindOfClass:c]) {
			fromType = NSStringFromClass(c);
			break;
		}
	}

	assert(fromType != nil);
	NSValueTransformer *transformer = nil;
	NSString *forwardTransformerName = [NSString stringWithFormat:@"MTA%@To%@ValueTransformer", fromType, toType];
	transformer = [NSValueTransformer valueTransformerForName:forwardTransformerName];
	if (transformer) {
		return [transformer transformedValue:value];
	}

	NSString *reverseTransformerName = [NSString stringWithFormat:@"MTA%@To%@ValueTransformer", toType, fromType];
	transformer = [NSValueTransformer valueTransformerForName:reverseTransformerName];
	if (transformer && [[transformer class] allowsReverseTransformation]) {
		return [transformer reverseTransformedValue:value];
	}

	return [[NSValueTransformer valueTransformerForName:@"MTAPassThroughValueTransformer"] transformedValue:value];
}
