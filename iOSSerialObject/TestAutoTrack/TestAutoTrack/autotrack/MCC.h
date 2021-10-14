//
//  MCC.h
//  cloudconfig
//
//  Created by xiang on 27/02/2017.
//  Copyright © 2017 xiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "mccDataRecord.h"

@protocol MCCDelegate <NSObject>

//有配置文件要下载，启动下载
- (void)mccConfigDidGotFileAndBeginDownload:(NSString *)platform;

//配置文件下载完成
- (void)mccConfigDidFileDownloadCompleted:(NSString *)platform;

//配置完全获取完成
- (void)mccConfigDidGotNewConfig:(NSString *)platform fileDict:(NSDictionary *)fileDict configDict:(NSDictionary *)configDict;

//出错
- (void)mccConfigDidGotError:(NSString *)platform errorCode:(NSInteger)errorCode;

@end

@interface MCC : NSObject

@property (nonatomic, weak) id<MCCDelegate> delegate;

//注册业务到云控
- (BOOL)registerSDK:(NSString *)sdkPlatform sdkVersion:(NSString *)sdkVersion sdkAccessID:(NSString *)sdkAccessID;

//请求云端，是否有新的配置。 注意delegate传值
- (void)requestNewConfig:(NSString *)platform;

//获取本地的配置
- (void)getLocalConfig:(NSString *)platform;


@end


@interface MCCConfig : NSObject

//@property (nonatomic, assign) BOOL mccDebugEnable; //是否开启日志

+ (instancetype)getInstance;

@end
