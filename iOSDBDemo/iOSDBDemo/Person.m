//
//  Person.m
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)n age:(NSUInteger)a property:(NSDictionary *)p time:(NSDate *)t {
    if (self = [super init]) {
        self.name = n;
        self.age  = a;
        self.property = p;
        self.now      = t;
    }
    
    return self;
}


#pragma mark - NSCoding Delegate
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        // NSCoder 可以encode 一般数据类型
        
        // For performance reasons, you should avoid explicitly testing for keys when the default values are sufficient.
        // You should avoid using “$” as a prefix for your keys.
        // if you request a keyed value that does not exist, the unarchiver returns a default value based on the return type of the decode method you invoked. The default values are the equivalent of zero for each data type: nil for objects, NO for booleans, 0.0 for reals, NSZeroSize for sizes,
        if ([aDecoder containsValueForKey:@"name"]) {
            self.name = [aDecoder decodeObjectForKey:@"name"];
        }
        
        self.age  = [aDecoder decodeIntegerForKey:@"age"];
        self.property = [aDecoder decodeObjectForKey:@"property"];
        self.now      = [aDecoder decodeObjectForKey:@"time"];
        
        // NSCoder 可以encode 基于几何位置数据类型，CGPoint, CGRect, CGSize, CGAffineTransform,UIEdgeInsets UIOffset,CGVector
        self.geometry = [aDecoder decodeCGPointForKey:@"geometry"];
        
        // NSCoder 可以encode Core Media Time Structure数据类型
    }
    
    return self;
}

// the classes NSDistantObject, NSInvocation, NSPort, and their subclasses adopt NSCoding only for use by NSPortCoder within the distributed objects system; they cannot be encoded into an archive.
- (void)encodeWithCoder:(NSCoder *)aCoder {
    // The best technique for archiving a structure or a collection of bit fields is to archive the fields independently and choose the appropriate type of encoding/decoding method for each
    // Restricting Coder Support
    if ([aCoder isKindOfClass:[NSKeyedArchiver class]]) {
        [aCoder encodeObject:self.name forKey:@"name"];
        [aCoder encodeInteger:self.age forKey:@"age"];
        [aCoder encodeObject:self.property forKey:@"property"];
        [aCoder encodeObject:self.now forKey:@"time"];
        [aCoder encodeCGPoint:CGPointZero forKey:@"geometry"];
    } else {
        [NSException raise:NSInvalidArchiveOperationException format:@"Only supports NSKeyedArchiver coders"];
    }
}


#pragma mark - NSSecureCoding Delegate
//+ (BOOL)supportsSecureCoding {
//    return YES;
//}



@end
