//
//  KeychainManager.h
//  iOSDBDemo
//
//  Created by uwei on 8/17/16.
//  Copyright © 2016 forwardto9. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KeychainManager : NSObject

- (nonnull instancetype)initWithIdentifier:( NSString * _Nonnull )identifier associatedGroupIdentifier:(NSString * _Nullable)groupIdentifier;
- (BOOL)deleteItem:(nonnull id)item;
- (BOOL)updateItem:(nonnull id)item;
- (nullable id)itemWithCondition:(nullable id)condition;
- (BOOL)resetKeychain;

@end

