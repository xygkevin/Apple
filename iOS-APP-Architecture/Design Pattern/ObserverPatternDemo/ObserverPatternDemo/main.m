//
//  main.m
//  ObserverPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observer1.h"
#import "Observer2.h"
#import "Subject.h"
#import "ConcreteSubject.h"


// 简单来讲就一句话：当一个对象变化时，其它依赖该对象的对象都会收到通知，并且随着变化！对象之间是一种一对多的关系
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        Subject *subject = [ConcreteSubject new];
        Observer1 *ob1 = [Observer1 new];
        Observer2 *ob2 = [Observer2 new];
        
        [subject addObserver:ob1];
        [subject addObserver:ob2];
        
        [subject operation];
        
        
    }
    return 0;
}
