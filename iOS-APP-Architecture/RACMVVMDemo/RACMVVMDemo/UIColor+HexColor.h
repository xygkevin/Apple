//
//  UIColor+HexColor.h
//  RACMVVMDemo
//
//  Created by uwei on 2020/3/10.
//  Copyright © 2020 TEG of Tencent. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColor)
+ (UIColor *)colorWithHex:(NSUInteger)hex;
+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
