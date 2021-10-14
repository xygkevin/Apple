//
//
//  Created by xiangchen on 14/01/15.
//  Copyright (c) 2015 xiangchen. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface TTKUserDefaults : NSObject

+ (BOOL)setString:(NSString*)obj forKey:(NSString*)key;

+ (NSString*)getStringForKey:(NSString*)key;


+ (BOOL)setBool:(BOOL)obj forKey:(NSString*)key;

+ (BOOL)getBoolForKey:(NSString*)key;


+ (BOOL)setInt:(NSInteger)obj forKey:(NSString*)key;

+ (NSInteger)getIntForKey:(NSString*)key;

+ (BOOL)setObject:(NSObject*)obj forKey:(NSString*)key;
+ (id)getObjectForKey:(NSString*)key;

@end
