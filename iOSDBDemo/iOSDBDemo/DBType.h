//
//  DBType.h
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#ifndef DBType_h
#define DBType_h


typedef NS_ENUM(NSInteger,DBType) {
    Plist = 0,
    SQLite = 1,
    CoreData = 2,
    Keychain = 3,
    Achiver  = 4,
    SmallFile = 5
};

#endif /* DBType_h */
