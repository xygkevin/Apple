//
//  KeychainManager.m
//  iOSDBDemo
//
//  Created by uwei on 8/17/16.
//  Copyright © 2016 forwardto9. All rights reserved.
//
#import <Security/Security.h>
#import "KeychainManager.h"

@interface KeychainManager ()

@property (strong, nonatomic) NSMutableDictionary *keychainItemData;
@property (strong, nonatomic) NSMutableDictionary *keychainItemQuery;

@end

@implementation KeychainManager


- (instancetype)initWithIdentifier:(NSString *)identifier associatedGroupIdentifier:(NSString *)groupIdentifier {
    if (self = [super init]) {
        if (!self.keychainItemQuery) {
            self.keychainItemQuery = [[NSMutableDictionary alloc] init];
        } else {
            [self.keychainItemQuery removeAllObjects];
        }
        
        // step1. set item class
        [self.keychainItemQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        
        // step2. set item attribute
        [self.keychainItemQuery setObject:identifier forKey:(id)kSecAttrGeneric];
        
        if (groupIdentifier) {
#if TARGET_IPHONE_SIMULATER
            //
#else
            [self.keychainItemQuery setObject:groupIdentifier forKey:(id)kSecAttrAccessGroup];
#endif
            
        }
        
        // step3. set search attribute
        [self.keychainItemQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        
        // step4. set search return attribute
        
        // kSecReturnData, Return data attribute key.The corresponding value is of type CFBooleanRef. A value of kCFBooleanTrue indicates that the data of an item should be returned in the form of a CFDataRef. For keys and password items, data is secret (encrypted) and may require the user to enter a password for access.
        
        //  kSecReturnAttributes, Return attributes attribute key.The corresponding value is of type CFBooleanRef. A value of kCFBooleanTrue indicates that a dictionary of the (unencrypted) attributes of an item should be returned in the form of a CFDictionaryRef.
        
        //    kSecReturnRef, Return reference attribute key.The corresponding value is of type CFBooleanRef. A value of kCFBooleanTrue indicates that a reference should be returned. Depending on the item class requested, the returned references may be of type SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef.
        
        //    kSecReturnPersistentRef, Return persistent reference attribute key. A persistent reference to a credential can be stored on disk for later use or passed to other processes.The corresponding value is of type CFBooleanRef. A value of kCFBooleanTrue indicates that a persistent reference to an item (CFDataRef) should be returned.
        [self.keychainItemQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:self.keychainItemQuery];
        CFTypeRef outDictionary  = NULL;
         OSStatus keychainErr = noErr;
        keychainErr = SecItemCopyMatching((CFDictionaryRef)tempDictionary, &outDictionary);
        if (keychainErr != noErr) { // 如果没找到对应的item
            [self resetKeychain];
            [self.keychainItemData setObject:[identifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrGeneric];
            if (groupIdentifier) {
#if TARGET_IPHONE_SIMULATER
                //
#else
                [self.keychainItemData setObject:groupIdentifier forKey:(id)kSecAttrAccessGroup];
#endif
            }
        } else { // 找到对应的item，将对应的item转换成字典
            self.keychainItemData = [self secItemFormatToDictionary:(__bridge_transfer NSDictionary *)outDictionary];
        }
    }
    
    return self;
}

// 将keychain中的数据读出来
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)secItemFormatDictionary {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:secItemFormatDictionary];
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

    CFTypeRef data = NULL;
    OSStatus keychainError = noErr; //
    keychainError = SecItemCopyMatching((CFDictionaryRef)returnDictionary, &data);
    if (keychainError == noErr) {
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        [returnDictionary setObject:(__bridge_transfer NSData *)data forKey:(id)kSecValueData];
    } else if (keychainError == errSecItemNotFound) {
        NSAssert(NO, @"Nothing was found in keychain!");
    } else {
        NSAssert(NO, @"Serious error!");
    }
    
    return returnDictionary;
}

// 将字典数据保存到keychain中
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSMutableDictionary *)toConvertDictionary {
    NSMutableDictionary *secItemDictionary = [NSMutableDictionary dictionaryWithDictionary:toConvertDictionary];
    [secItemDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    id data = [toConvertDictionary objectForKey:(id)kSecValueData];
    [secItemDictionary setObject:data forKey:(id)kSecValueData];
    
    return secItemDictionary;
}


- (BOOL)updateItem:(id)item {
    BOOL addResult = NO;
    if (item) {
        if ([item isKindOfClass:[NSString class]]) {
            [self.keychainItemData setObject:[item dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
//            [self.keychainItemQuery setObject:[item dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            [self.keychainItemData setObject:[NSKeyedArchiver archivedDataWithRootObject:item] forKey:(id)kSecValueData];
        }
        
        CFTypeRef attributes = nil;
        
        OSStatus result = noErr;
        // 查找是否已经已经存在
        if (SecItemCopyMatching((CFDictionaryRef)self.keychainItemQuery, &attributes) == noErr) { // 已存在，则更新
            NSMutableDictionary *itemQuery = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)attributes];
            [itemQuery setObject:[self.keychainItemQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
            NSMutableDictionary *updateItem = [self dictionaryToSecItemFormat:self.keychainItemData];
            [updateItem removeObjectForKey:(id)kSecClass];
#if TARGET_IPHONE_SIMULATER
            [updateItem removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
            result = SecItemUpdate((CFDictionaryRef)itemQuery, (CFDictionaryRef)updateItem);
            
        } else { // 不存在，则添加
            result = SecItemAdd((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:self.keychainItemData], NULL);
        }
        
        if (result == noErr) {
            addResult = YES;
        } else {
            addResult = NO;
        }
        
    } else {
        addResult = NO;
    }
    
    
    return addResult;
}

- (BOOL)deleteItem:(id)item {
    
    BOOL deleteResult = NO;
    // no need to set kSecValueData because of keychainItemData had the kSecValueData value at init method
    
//    if ([item isKindOfClass:[NSString class]]) {
//        [self.keychainItemData setObject:[item dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
//    } else if ([item isKindOfClass:[NSDictionary class]]) {
//        [self.keychainItemData setObject:[NSKeyedArchiver archivedDataWithRootObject:item] forKey:(id)kSecValueData];
//    }
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:self.keychainItemData]);
    if (status == noErr) {
        deleteResult = YES;
    } else if (status == errSecItemNotFound) {
        deleteResult = YES;
    } else {
        deleteResult = NO;
    }
    
    return deleteResult;
}

- (id)itemWithCondition:(id)condition {
    id result = nil;
    // 将查找条件放到user-define中
    [self.keychainItemQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [self.keychainItemQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    CFTypeRef keychainResult = NULL;
    // 即可以检索属性项，也可以检索更多项，这个地方就是为了检索kSecRetuenData项，因为我们的数据就在这个项里保存着.
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)self.keychainItemQuery, &keychainResult);
    [self.keychainItemQuery removeObjectForKey:(id)kSecValueData];
    [self.keychainItemQuery removeObjectForKey:(id)kSecClass];
    if (status == noErr) {
        NSDictionary *r = (__bridge_transfer NSDictionary *)keychainResult;
        
        // first convert to NSString
        result = [[NSString alloc] initWithData:(NSData *)[r objectForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding];
        if (!result) { // Convert to NSString failed,then try Dictionary
            result = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[r objectForKey:(id)kSecValueData]] objectForKey:condition];
        }
        
    } else {
        result = nil;
    }
    
    return result;
}

- (BOOL)resetKeychain {
    BOOL resetResult = NO;
    OSStatus junk = noErr;
    if (!self.keychainItemData) {
        self.keychainItemData = [[NSMutableDictionary alloc] init];
        resetResult = YES;
    } else if (self.keychainItemData) {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:_keychainItemData];
        junk = SecItemDelete((CFDictionaryRef)tempDictionary);
        if (junk == noErr || junk == errSecItemNotFound) {
            resetResult = YES;
        }  else {
            resetResult = NO;
        }
    }
    
    // Default generic data for Keychain Item:
    [self.keychainItemData setObject:@"Item label" forKey:(__bridge id)kSecAttrLabel];
    [self.keychainItemData setObject:@"Item description" forKey:(__bridge id)kSecAttrDescription];
    [self.keychainItemData setObject:@"Account" forKey:(__bridge id)kSecAttrAccount];
    [self.keychainItemData setObject:@"Service" forKey:(__bridge id)kSecAttrService];
    [self.keychainItemData setObject:@"Your comment here." forKey:(__bridge id)kSecAttrComment];
    [self.keychainItemData setObject:@"" forKey:(__bridge id)kSecValueData];
    
    return resetResult;
}

@end
