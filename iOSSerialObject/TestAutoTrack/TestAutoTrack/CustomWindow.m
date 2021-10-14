//
//  CustomWindow.m
//  TestAutoTrack
//
//  Created by uwei on 15/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hit");
    return nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch");
}

@end
