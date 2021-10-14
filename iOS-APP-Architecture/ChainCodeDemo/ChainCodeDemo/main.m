//
//  main.m
//  ChainCodeDemo
//
//  Created by uwei on 6/14/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculater : NSObject

@property (assign, readonly) int result;

- (Calculater *(^)(int))add;
- (Calculater *(^)(int))subtract;



@end


@interface Calculater () {
    int calculaterResult;
}

@end

@implementation Calculater

- (instancetype)init {
    if (self = [super init]) {
        calculaterResult = 0;
    }
    return self;
}

- (int)result {
    return calculaterResult;
}

- (Calculater *(^)(int))add {
    return ^Calculater*(int value) {
        calculaterResult += value;
        return self;
    };
}

- (Calculater *(^)(int))subtract {
    return ^Calculater*(int value) {
        calculaterResult -= value;
        return self;
    };
}

@end


@interface NSObject (Calculater)

+ (int)makeCalculater:(void(^)(Calculater *))block;

@end

@implementation NSObject (Calculater)

+ (int)makeCalculater:(void (^)(Calculater *))block {
    Calculater *c = [Calculater new];
    block(c);
    return c.result;
}

@end





int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        
        int result = [NSObject makeCalculater:^(Calculater *c) {
            c.add(3).subtract(1);
        }];
        NSLog(@"result = %d", result);
        
    }
    return 0;
}
