//
//  Subject.h
//  ObserverPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObserverProtocol.h"

@protocol SubjectProtocol <NSObject>

- (void)addObserver:(id<ObserverProtocol>)observer;
- (void)deleteObserver:(id<ObserverProtocol>)observer;
- (void)notifyAllObserver;
@optional
- (void)operation;

@end