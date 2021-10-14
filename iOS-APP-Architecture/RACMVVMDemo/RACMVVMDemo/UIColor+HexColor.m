//
//  UIColor+HexColor.m
//  RACMVVMDemo
//
//  Created by uwei on 2020/3/10.
//  Copyright © 2020 TEG of Tencent. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHex:(NSUInteger)hex
{
    return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    NSUInteger red = ((hex & 0xff0000) >> 16);
    NSUInteger green = ((hex & 0xff00) >> 8);
    NSUInteger blue = (hex & 0xff);
    CGFloat r = (CGFloat)red / 255.0f;
    CGFloat g = (CGFloat)green  / 255.0f;
    CGFloat b = (CGFloat)blue / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}
@end
