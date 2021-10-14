//
//  ConcreteSubject.m
//  ObserverPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import "ConcreteSubject.h"

@implementation ConcreteSubject

- (void)operation {
    NSLog(@"Self operation finished, then notify other observer to update");
    [self notifyAllObserver];
}

@end
