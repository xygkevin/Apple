//
//  Person.h
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Person : NSObject<NSCoding/*, NSSecureCoding */>

//In order to conform to NSSecureCoding:
//An object that does not override initWithCoder: can conform to NSSecureCoding without any changes (assuming that it is a subclass of another class that conforms).
//An object that does override initWithCoder: must decode any enclosed objects using the decodeObjectOfClass:forKey: method. For example:
//OBJECTIVE-C
//id obj = [decoder decodeObjectOfClass:[MyClass class]
//In addition, the class must override its supportsSecureCoding method to return YES.

- (instancetype)initWithName:(NSString *)n age:(NSUInteger)a property:(NSDictionary *)p time:(NSDate *)t;

@property (nonatomic, copy) NSString *name;
@property (atomic, assign)  NSUInteger age;
@property (nonatomic, strong) NSDictionary *property;
@property (nonatomic, strong) NSDate *now;
@property (nonatomic, assign) CGPoint geometry;

@end
