//
//  ConcreteSubject.m
//  ObserverPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import "ConcreteSubject.h"

@implementation Subject

- (instancetype)init {
    
    if (self == [super init]) {
        set = [[NSMutableSet alloc] init];
    }
    
    return self;
    
}


- (void)addObserver:(id<ObserverProtocol>)observer {
    [set addObject:observer];
}

- (void)deleteObserver:(id<ObserverProtocol>)observer {
    [set removeObject:observer];
}

- (void)notifyAllObserver {
    for (id observer in set) {
        [observer update];
    }
}


@end
