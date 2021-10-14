//
//  TTKBaseHelper.h
//  basefunction
//
//  Created by xiang on 6/11/15.
//
//

#import <Foundation/Foundation.h>

@interface TTKBaseHelper : NSObject

+(void)Log:(NSString *)info;
+(void)Log:(NSString *)info value:(NSString *)value;

+(NSString*)getJson:(id) dictOrArray;
+(id)json2Obj:(NSString*)jsonStr;

+ (NSDate *)dateFromString:(NSString *)dateString;
+(NSDate*)getDateFromUTime:(uint64_t)uTime;
+(NSString*)getUTimeFromDate:(NSDate*)date;

+(char *)getCharFromNSString:(NSString*)nsStr;
+(NSString*)md5Data:(NSData*)data;
+(NSString*)md5:(NSString*)str;
+(NSString*)getQueryString:(NSDictionary*)dict;

+(NSString*)replaceUnicode:(NSString*)unicodeStr;

@end
