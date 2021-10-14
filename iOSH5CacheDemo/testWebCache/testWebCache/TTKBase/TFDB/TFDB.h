//
//  TTKTFDB.h
//  TTKTFDB
//
//  Created by tyzual on 8/26/15.
//  Copyright (c) 2015 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTKTFDB : NSObject

/**
 *  工厂方法
 *
 *  @param dbId 数据库标识
 *			若标识符所对应的数据库已经打开
 *			则返回打开的那个
 *			否则创建一个新的数据库
 *
 *  @return 数据库实例
 */
+ (instancetype)TfdbWithDbid:(NSString *) dbId;

/**
 *  初始化方法
 *
 *  @param dbId 数据库标识
 *			若标识符所对应的数据库已经打开
 *			则返回打开的那个
 *			否则创建一个新的数据库
 *
 *  @return 数据库实例
 */
- (instancetype)initWithDbid:(NSString *) dbId;

/**
 *  写入数据
 *  返回时可以保证数据己写入硬盘
 *
 *  @param data 待写入的数据
 *  @param key  待写入数据的key
 *
 *  @return 执行结果 YES表示成功,NO表示失败
 */
- (BOOL)writeData:(NSData *) data withKey:(NSString *) key;

/**
 *  异步写入数据
 *  回调调用时可以保证数据已写入硬盘
 *
 *  @param data 待写入的数据
 *  @param key  待写入数据的key
 *  @param callBack 写入完成的回调
 *					若写入成功,回调的参数为YES,否则为NO
 */
- (void)asyncWriteData:(NSData *) data withKey:(NSString *) key callback:(void(^)(BOOL)) callBack;

/**
 *  批量写入数据
 *	有大量数据写入时推荐用此方法一次性写入
 *
 *  @param datas 需要写入的数据
 *				字典key的类型为NSString *,表示待写入数据的key
 *				字典Value的类型为NSData *,表示待写入的数据
 *
 *  @return 执行结果 YES表示成功,NO表示失败
 */
- (BOOL)writeDatas:(NSDictionary *) datas;

/**
 *  异步批量写入数据
 *	有大量数据写入时推荐用此方法一次性写入
 *
 *  @param datas 需要写入的数据
 *				字典key的类型为NSString *,表示待写入数据的key
 *				字典Value的类型为NSData *,表示待写入的数据
 *  @param callBack 写入完成的回调
 *					若写入成功,回调的参数为YES,否则为NO
 */
- (void)asyncWriteDatas:(NSDictionary *) datas callback:(void(^)(BOOL)) callBack;

/**
 *  读取数据
 *
 *  @param key 写入数据时所用的key
 *
 *  @return key对应的数据,key不存在时返回nil
 */
- (NSData *)getDataWithKey:(NSString *) key;

/**
 *  异步读取数据
 *
 *  @param key 写入数据时所用的key
 *  @param callBack 读取完成时的回调
 *					若读取成功,回调中NSData *为key对应的数据
 *					否则返回nil
 */
- (void)asyncGetDataWithKey:(NSString *) key callback:(void(^)(NSData *)) callBack;

/**
 *  删除数据
 *
 *  @param key 写入数据时所用的key
 *
 *  @return 执行结果 YES表示成功,NO表示失败
 */
- (BOOL)delDataWithKey:(NSString *) key;

/**
 *  异步删除数据
 *  回调调用时可以保证数据已经删除
 *
 *  @param key 写入数据时所用的key
 *  @param callBack 删除完成时的回调
 *					若删除成功,回调的参数为YES,否则为NO
 */
- (void)asyncDelDataWithKey:(NSString *) key callBack:(void(^)(BOOL)) callBack;

/**
 *  批量删除数据
 *
 *  @param keys 需要删除key的列表
 *				keys中的元素为NSString *,表示需要删除的数据对应的key
 *
 *  @return 执行状态 成功返回YES,失败返回NO
 */
- (BOOL)delDatas:(NSArray *) keys;

/**
 *  异步批量删除数据
 *
 *  @param keys 需要删除key的列表
 *				keys中的元素为NSString *,表示需要删除的数据对应的key
 *  @param callBack 删除完成时的回调
 *					若删除成功,回调的参数为YES,否则为NO
 */
- (void)asyncDelDatas:(NSArray *) keys callBack:(void(^)(BOOL)) callBack;

/**
 *  判断key是否存在
 *
 *  @param key key
 *
 *  @return YES表示key存在,NO表示不存在
 */
- (BOOL)containKey:(NSString *) key;

/**
 *  异步判断key是否存在
 *  注意,回调调用时数据库可能已经发生改变
 *  调用者需要保证函数返回到回调调用这段时间
 *  数据库没有改变
 *
 *  @param key      key
 *  @param callBack 若key存在,则回调的参数为YES,否则为NO
 */
- (void)asyncContainKey:(NSString *) key callBack:(void(^)(BOOL)) callBack;

/**
 *  返回数据库中带有指定前缀的key
 *
 *  @param prefix 前缀
 *
 *  @return 带有指定前缀的key的集合
 *			若数据库中没有符合条件的key,则返回nil
 *			NSArray中每个元素的类型为NSString *
 */
- (NSArray *)keysWithPrefix:(NSString *) prefix;

/**
 *  异步获取数据库中带有指定前缀的key
 *  注意,回调调用时数据库可能已经发生改变
 *  调用者需要保证函数返回到回调调用这段时间
 *  数据库没有改变
 *
 *  @param prefix   前缀
 *  @param callBack 执行完成时候的回调
 *					回调的参数为符合条件key的集合
 *					若数据库中没有符合条件的key,回调的参数为nil
 *					NSArray参数中每个元素的类型为NSString *
 */
- (void)asyncKeysWithPrefix:(NSString *) prefix callBack:(void(^)(NSArray *)) callBack;

@end
