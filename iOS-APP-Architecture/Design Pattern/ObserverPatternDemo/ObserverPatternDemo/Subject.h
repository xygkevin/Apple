//
//  ConcreteSubject.h
//  ObserverPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubjectProtocol.h"
@interface Subject : NSObject<SubjectProtocol> {
    NSMutableSet *set;
}

@end
