//
//  ViewController.m
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "KeychainManager.h"
#import <sqlite3.h>
#import "Book.h"
#import <Realm/Realm.h>
#import <CloudKit/CloudKit.h>
#define kTableName @"Book"

// function pointer
typedef int(*SQLiteCallback)(void*,int,char**,char**);


@interface Engineer : RLMObject

@property (copy, nonatomic, nullable) NSString *name;
@property (assign, nonatomic) NSNumber<RLMInt> *age;

@end

@implementation Engineer
@end


@interface ViewController () {
    sqlite3 *sqliteDB;
}

@property (strong, nonatomic) CKDatabase *ckPublicDataBase;
@property (strong, nonatomic) CKDatabase *ckPrivateDataBase;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [self plistFilePath];
    
    if ([self saveDataToPlist:filePath]) {
        //
    }
    
    NSLog(@"Data :%@", [self dataFromPlist:filePath]);
    
    [self deleteDataFromPlist:filePath k:@"key1"];
    NSLog(@"Data :%@", [self dataFromPlist:filePath]);
    
    
    for (int i = 0; i < 9; ++i) {
        [self queryDataFromPlist:filePath k:@"key2"];
    }
    [self userDefaultDemo];
    [self archiverDataDemo];
    [self serializeDataDemo];
    
    KeychainManager *keychainManager =[[KeychainManager alloc] initWithIdentifier:@"uwei" associatedGroupIdentifier:nil];
    [keychainManager updateItem:@"uweiyuan"];
    NSLog(@"before delete value:%@", [keychainManager itemWithCondition:nil]);
    [keychainManager deleteItem:@"uweiyuan"];
    NSLog(@"after delete value:%@", [keychainManager itemWithCondition:nil]);
    
    [keychainManager updateItem:@{@"keychain-key":@"keychain-value"}];
    NSLog(@"before delete value:%@", [keychainManager itemWithCondition:@"keychain-key"]);
    [keychainManager deleteItem:@{@"keychain-key":@"keychain-value"}];
    NSLog(@"after delete value:%@", [keychainManager itemWithCondition:@"keychain-key"]);
    
    NSString *sqliteDBPath = [self sqliteFilePath];
    
    [self connectSQLiteDB:sqliteDBPath];
    [self insertData:@"uwei"];
    [self insertData:@"12345"];
    
    [self queryDataWithCompletionHander:callback];
    
    [self closeSQLiteDB];
    
    [self insertIntoCoreData];
    [self queryCoreData];
    [self updateCoreData];
    [self queryCoreData];
    [self deleteCoreData];
    
    
    [self insertDataIntoRealm];
    [self queryDataFromRealm];
    [self updateDataInRealm];
    [self queryDataFromRealm];
    [self deleteDatafromRealm];
    [self queryDataFromRealm];
    
    [self insertDataIntoPasteboard];
    [self queryDataFromPasteboard];
    [self updateDataFromPasteboard];
    [self queryDataFromPasteboard];
    [self deleteDataFromPasteboard];
    [self queryDataFromPasteboard];
    
    [self connectToiCloud];
//    [self insertiCloudData];
    [self queryiCloudData];
    [self subscribeiCloud];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Plist Data Operation
- (BOOL)saveDataToPlist:(NSString *)filePath {
    BOOL status = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        status = YES;
        NSLog(@"[Plist] plist file existed!");
        NSError *removeItemError = nil;
        [manager removeItemAtPath:[self plistFilePath] error:&removeItemError];
        if (removeItemError) {
            NSLog(@"[Plist] Remove Plist File Failed! Error info:%@", [removeItemError localizedDescription]);
        }
    }
    NSLog(@"[Plist] create plist file");
    NSDictionary *plistData = @{@"key1":@111, @"key2":@"value2", @"key3": @YES, @"key4":@[@2,@3,@4], @"key5":@{@"key11":@"value11"}};
    status = [plistData writeToFile:filePath atomically:YES];
    
    
    return status;
}

- (id)dataFromPlist:(NSString *)filePath {
    id data = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        data = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    }
    
    return data;
}

- (void)deleteDataFromPlist:(NSString *)filePath k:(NSString *)k {
    // 1.要知道根类型(NSArray, NSDictionary)
    // 2.涉及到递归的问题
    NSMutableDictionary *data = [self dataFromPlist:filePath];
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([(NSString *)key isEqualToString:k]) {
            *stop = YES;
            [data removeObjectForKey:key];
            NSLog(@"[Plist] delete key pair OK!");
            
            // 3.需要重新写文件进行保存
            [data writeToFile:filePath atomically:YES];
        }
    }];
}

- (id)queryDataFromPlist:(NSString *)filePath k:(NSString *)k {
    // 没有增量分页查询，只能一次性将全部数据load到内存中
    // 优点：速度快，缺点:占资源
    NSMutableDictionary *data = [self dataFromPlist:filePath];
    id result = [data objectForKey:k];
    return result;
}

- (NSString *)plistFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"demo.plist"];
    return filePath;
}

#pragma mark - UserDefault Data Operation
- (void)userDefaultDemo {
    // 以字典的形式写入plist文件，并保存在sandbox中的Library/Perferences/{BundleID}.plist
    // 通过系统默认的保存路径可以看出，这个数据存储主要用来实现：创建并保存用户的偏好设置
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setBool:YES forKey:@"bool key"];
    [userPreferences setInteger:111 forKey:@"int key"];
    [userPreferences setObject:[NSData new] forKey:@"nsdata key"];
    [userPreferences setObject:[NSDate date] forKey:@"nadate key"];
    [userPreferences setObject:@"string" forKey:@"string key"];
    [userPreferences synchronize];
    
    // 转换成NSData保存在对应的key中
    [userPreferences setURL:[NSURL URLWithString:@"http://www.qq.com"] forKey:@"url"];
    [userPreferences synchronize];
    
    NSURL *url = [userPreferences URLForKey:@"url"];
    NSLog(@"[UserDefaults] url :%@",url.absoluteString);
}

#pragma mark - Archiver Data Operation
- (void)archiverDataDemo {
    
    NSError *removeItemError = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self archiverFilePath]]) {
        [manager removeItemAtPath:[self archiverFilePath] error:&removeItemError];
        if (removeItemError) {
            NSLog(@"[Archiver] Remove Archiver File Failed! Error info:%@", [removeItemError localizedDescription]);
        }
    }

    NSMutableArray *persons = [NSMutableArray new];
    for (int i = 0; i < 99; ++i) {
        Person *person = [[Person alloc] initWithName:@"uwei" age:i property:@{@"where":@"shenzhen"} time:[NSDate date]];
        [persons addObject:person];
    }
    
    // 可以归档的对象必须是遵从了NSCoding协议的对象，如果有关联其他对象，那么必须要所有的对象都要遵循NSCoding协议，否则都会有异常
    // Your application can use an archive as the storage medium of your data model
    [NSKeyedArchiver archiveRootObject:persons toFile:[self archiverFilePath]];
    // However, if you want to customize the archiving process,use initForWritingWithMutableData: method
//    Person *aPerson = <>;
//    NSString *archivePath = <Path for the archive#>;
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:aPerson forKey:ASCPersonKey];
//    [archiver finishEncoding];
//    
//    NSURL *archiveURL = <URL for the archive#>;
//    BOOL result = [data writeToURL:archiveURL atomically:YES];
    
    // 这里可以看到：解开的时候是以文件路径为参数，并将文件的内容全部解开到某种集合类型中
    // 优点：解开的就是对象，方便使用
    // 缺点：必须要解开文件的全部内容，如果我们想要获取满足某一条件的对象，必须要全部解开，然后进行筛选，占用资源比较多，且性能不会太好,解决的办法就是不要解开所有的key，而是解开自己需要的key就可以
    NSArray *ps = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiverFilePath]];
    [ps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 这里的obj对象是对数组的强引用，所以可以通过这个对象修改文件中的数据
        if (((Person *)obj).age == 28) {
            *stop = YES;
            ((Person *)obj).name = @"yuan";
            ((Person *)obj).property = @{@"color":@"yellow"};
            ((Person *)obj).now      = [NSDate date];
        }
    }];
    // 为了保存我们修改的值，必须要将整个数组重新写到文件中，而不能实现差分修改文件中的数据
    [NSKeyedArchiver archiveRootObject:ps toFile:[self archiverFilePath]];
    NSArray *pss = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiverFilePath]];
    
    [pss enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((Person *)obj).age == 28) {
            *stop = YES;
            NSLog(@"[Archiver] person name:%@, age:%lu, perperty:%@,now:%@", ((Person *)obj).name, ((Person *)obj).age, ((Person *)obj).property, ((Person *)obj).now);
        }
    }];
}

- (NSString *)archiverFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"archiver.data"];
    return filePath;
}

#pragma mark - Serialization Data Operation
// 序列化，将OC类型(即，Plist文件支持的所有数据类型)在架构无关的字节流之间转换，与归档相比，序列化不会记录数据类型以及它们之间的关系，只有它们自己记录，而且反序列化的顺序要自己控制.
// 可以将数据保存成plist格式的文件，也可以将数据保存成二进制格式的文件.
- (void)serializeDataDemo {
    NSDictionary *serializationData = @{@"key1":@"value1", @"key2":@1};
    NSError *errorString = nil;
    // 这里formate决定了写入文件的格式：
    // NSPropertyListXMLFormat_v1_0,    Specifies the XML property list format.
    // NSPropertyListBinaryFormat_v1_0, Specifies the binary property list format.
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:serializationData format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListImmutable error:&errorString];
    if (errorString) {
        NSLog(@"[Serialization] serialization error:%@", errorString.localizedDescription);
    } else {
        
        NSFileManager *manager  = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:[self serializationFilePath]]) {
            NSError *removeItemError = nil;
            [manager removeItemAtPath:[self serializationFilePath] error:&removeItemError];
            if (removeItemError) {
                NSLog(@"[Serialization] Remove Serialization File Failed! Error info:%@", [removeItemError localizedDescription]);
            }
        }
        
        [data writeToFile:[self serializationFilePath] atomically:YES];
    }
    
    NSData *d = [NSData dataWithContentsOfFile:[self serializationFilePath]];
    NSError *err = nil;
    NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:d options:NSPropertyListImmutable format:NULL error:&err];
    if (err) {
        NSLog(@"[Serialization] deserialization error:%@", err.localizedDescription);
    } else {
        NSLog(@"[Serialization] deserialization result :%@", dic);
    }
}

- (NSString *)serializationFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"serialization.b"];
    return filePath;
}

#pragma mark - SQLite
- (NSString *)sqliteFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *sqliteDBPath = [path stringByAppendingPathComponent:@"sqlite.db"];
    
    return sqliteDBPath;
}

- (BOOL)connectSQLiteDB:(NSString *)dbPath {
    BOOL status = NO;
    
    NSFileManager *manager  = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dbPath]) {
        NSError *removeItemError = nil;
        [manager removeItemAtPath:dbPath error:&removeItemError];
        if (removeItemError) {
            NSLog(@"[SQLite] Remove Serialization File Failed! Error info:%@", [removeItemError localizedDescription]);
        }
    }
    
    status = sqlite3_open([dbPath UTF8String], &sqliteDB);
    if (status) {
        NSAssert(status, @"[SQLite] open sqilte db failed!");
    } else {
        fprintf(stdout, "[SQLite] open sqlite db success!\n");
    }
    
    return status;
}

- (void)closeSQLiteDB {
    if (sqliteDB) {
        sqlite3_close(sqliteDB);
        sqliteDB = NULL;
    }
}

- (BOOL)insertData:(id)data {
    BOOL status = NO;
    
    
    
    NSString *createTableSQL = @"create table if not exists data_table (id integer primary key autoincrement, value txt not null, note txt)";
    char * errorCreateMessage = NULL;
    status = sqlite3_exec(sqliteDB, [createTableSQL UTF8String], NULL, NULL, &errorCreateMessage);
    if (status) {
        NSAssert(status != SQLITE_OK, [NSString stringWithUTF8String:errorCreateMessage]);
    } else {
        NSLog(@"[SQLite] create table success!");
    }
    
    NSString *createLogTableSQL = @"create table if not exists log_table (id integer primary key autoincrement, create_time txt)";
    char *createLogTableErrorMessage = NULL;
    sqlite3_exec(sqliteDB, [createLogTableSQL UTF8String], NULL, NULL, &createLogTableErrorMessage);
    if (createLogTableErrorMessage) {
        NSLog(@"%@", [NSString stringWithUTF8String:createLogTableErrorMessage]);
    }
    
    char *createInsertTriggerErrorMessage = NULL;
    NSString *createInsertTriggerSQL = @"create trigger if not exists log  after insert on data_table begin insert into log_table (create_time) values (datetime('now')); end;";
    sqlite3_exec(sqliteDB, [createInsertTriggerSQL UTF8String], NULL, NULL, &createInsertTriggerErrorMessage);
    if (createInsertTriggerErrorMessage) {
        NSLog(@"%@", [NSString stringWithUTF8String:createInsertTriggerErrorMessage]);
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into data_table (value, note) values ('%@', 'default')", data];
    char * errorInsertMessage = NULL;
    status = sqlite3_exec(sqliteDB, [insertSQL UTF8String], NULL, NULL, &errorInsertMessage);
    if (status != SQLITE_OK) {
        NSAssert(1, [NSString stringWithUTF8String:errorInsertMessage]);
    } else {
        NSLog(@"[SQLite] insert a record success!");
    }
    
    /*
     The life-cycle of a prepared statement object usually goes like this:
     
     1. Create the prepared statement object using sqlite3_prepare_v2().
     2. Bind values to parameters using the sqlite3_bind_*() interfaces.
     3. Run the SQL by calling sqlite3_step() one or more times.
     4. Reset the prepared statement using sqlite3_reset() then go back to step 2. Do this zero or more times.
     5. Destroy the object using sqlite3_finalize().
     */
    NSString *insertSQL1 = @"insert into data_table (value, note) values (?, ?)";
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(sqliteDB, [insertSQL1 UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) { // compile sql ok, then
        
        // bing data to column index
        sqlite3_bind_text(stmt, 1, "value1", -1, NULL);
        sqlite3_bind_text(stmt, 2, "value2", -1, NULL);
        
        // execute compiled sql
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"[SQLite] insert a recode success!");
        } else {
            NSLog(@"[SQLite] insert a recode failed!");
        }
    } else {
        NSLog(@"[SQLite] insert a recode failed!");
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    return status;
}

- (BOOL)deleteData:(id)data {
    BOOL status = NO;
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from data_table where value = '%@'", data];
    char * deleteErrorMessage = NULL;
    status = sqlite3_exec(sqliteDB, [deleteSQL UTF8String], NULL, NULL, &deleteErrorMessage);
    if (deleteErrorMessage) {
        NSLog(@"[SQLite] %@", [NSString stringWithUTF8String:deleteErrorMessage]);
    }
    
    return status;
}

- (BOOL)queryDataWithCompletionHander:(SQLiteCallback)callback {
    BOOL status = NO;
    NSString *querySQL = [NSString stringWithFormat:@"select * from data_table"];
    char *queryErrorMessage = NULL;
    status = sqlite3_exec(sqliteDB, [querySQL UTF8String], callback, NULL, &queryErrorMessage);
    
    if (status != SQLITE_OK) {
        NSLog(@"[SQLite] %@", [NSString stringWithUTF8String:queryErrorMessage]);
    }
    
    char *query = "select * from data_table";
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(sqliteDB, query, -1, &stmt, NULL) == SQLITE_OK) { // compile sql ok, then
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // get index = 0 column
            int ID = sqlite3_column_int(stmt, 0);
            // get index = 1 column
            char *value = (char *)sqlite3_column_text(stmt, 1);
            // ...
            char *note  = (char *)sqlite3_column_text(stmt, 2);
            
            NSLog(@"[SQLite] ID = %d, value = %s, note = %s", ID, value, note);
        }
    } else {
        NSLog(@"[SQLite] query SQL exists error!");
    }
    
    if (stmt) {
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        stmt = NULL;
    }
    
    
    return status;
}

static int callback (void* data,int argc,char** argv,char**columnName) {
    fprintf(stdout, "%s\n", (const char *)data);
    for (int i = 0; i < argc; ++i) {
        printf("[SQLite] %s = %s\n", columnName[i], argv[i]);
    }
    printf("\n");
    return 0;
};

#pragma mark - CoreData Operation
- (BOOL)insertIntoCoreData {
    BOOL result = NO;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    @try {
        // if the table name is incorrect, then this method will raise an exception,and application will terminal.
        // +entityForName: could not locate an entity named 'BOOK' in this model
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:kTableName inManagedObjectContext:context];
        book.author = @"uwei";
        book.title  = @"Xcode";
        book.copyright = [NSDate date];
        book.pageCount = @1568;
        
        NSError *error = nil;
        result = [context save:&error];
        if (!result) {
            NSLog(@"[CoreData insert data failed:%@]", [error localizedDescription]);
        }

    } @catch (NSException *exception) {
        NSLog(@"[CoreData] Raise an exception:%@", [exception description]);
    } @finally {
        //
    }
    
    return result;
}

- (BOOL)deleteCoreData {
    BOOL result = NO;
    NSManagedObjectContext *context = self.managedObjectContext;
    
    @try {
        // if the table name is incorrect, this method will raise an exception and the application will terminal.
        // A fetch request must have an entity.
        // 声明要操作的表名
        NSEntityDescription *entity = [NSEntityDescription entityForName:kTableName inManagedObjectContext:context];
        // 声明一个操作请求
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // Specifying Fetch Constraints，NSFetchRequest实例对象的属性支持条件查询，相当于 SQL中的 where 语句
        request.includesPropertyValues = NO;
        request.entity = entity;
        NSError *error = nil;
        
        // 1. fetch request
        NSArray *datas = [context executeFetchRequest:request error:&error];
        if ((!error) && (datas.count > 0) && (datas)) {
            for (NSManagedObject *object in datas) {
                // 2. delete operation
                [context deleteObject:object];
            }
            
            // 3. save context
            result = [context save:&error];
            if (error) {
                NSLog(@"[CoreData] delete data failed! error info:%@", [error localizedDescription]);
            }
        }

    } @catch (NSException *exception) {
        NSLog(@"[CoreData] Raise an exception:%@", [exception description]);
    } @finally {
        //
    }
    
    return result;
}

- (BOOL)queryCoreData {
    BOOL result = NO;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    @try {
        // if the table name is incorrect, this method will raise an exception and the application will terminal.
        // A fetch request must have an entity.
        NSEntityDescription *entity     = [NSEntityDescription entityForName:kTableName inManagedObjectContext:context];
        NSPredicate *queryCondition     = [NSPredicate predicateWithFormat:@"author like[cd] %@", @"uwei"];
        NSFetchRequest *request         = [[NSFetchRequest alloc] init];
        request.entity                  = entity;
        request.predicate               = queryCondition;
        NSError *error                  = nil;
        NSArray *datas                  = [context executeFetchRequest:request error:&error];
        if ((!error) && (datas) && (datas.count > 0)) {
            result = YES;
            for (Book *book in datas) {
                NSLog(@"[CoreData] author = %@, title = %@, copyright = %@, pageCount = %@", book.author, book.title, book.copyright, book.pageCount);
            }
        }

    } @catch (NSException *exception) {
        NSLog(@"[CoreData] Raise an exception:%@", [exception description]);
    } @finally {
        //
    }
    
    return result;
}

- (BOOL)updateCoreData {
    BOOL result = NO;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    @try {
        // if the table name is incorrect, this method will raise an exception and the application will terminal.
        // A fetch request must have an entity.
        NSEntityDescription *entity     = [NSEntityDescription entityForName:kTableName inManagedObjectContext:context];
        NSPredicate *updateCondition    = [NSPredicate predicateWithFormat:@"author like[cd] %@", @"uwei"];
        NSFetchRequest *request         = [[NSFetchRequest alloc] init];
        request.entity                  = entity;
        request.predicate               = updateCondition;
        
        NSError *error                  = nil;
        // 1. fetch data those you want to update
        NSArray *datas                  = [context executeFetchRequest:request error:&error];
        if ((!error) && (datas) && (datas.count > 0)) {
            // 2. update these objects
            for (Book *book in datas) {
                book.title = @"iOS Software Engineer";
            }
            // 3. save context then finish the updating
            result = [context save:&error];
            if (!result) {
                NSLog(@"[CoreData] update data failed! error info:%@", [error localizedDescription]);
            }
        }

    } @catch (NSException *exception) {
        NSLog(@"[CoreData] Raise an exception:%@", [exception description]);
    } @finally {
        //
    }
    
    return result;
}

#pragma mark - Realm Data Operation

- (NSURL *)applicationDocumentPath {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (void)insertDataIntoRealm {
    // delete previous file
    [[NSFileManager defaultManager] removeItemAtURL:[RLMRealmConfiguration defaultConfiguration].fileURL error:nil];
    
    Engineer *person1 = [Engineer new];
    person1.name = @"uwei";
    person1.age  = @28;
    
    Engineer *person2 = [Engineer new];
    person2.name = @"yuan";
    person2.age  = @29;
    
/*
     Custom define the db path
    NSURL *path = [[self applicationDocumentPath] URLByAppendingPathComponent:@"db.realm"];
    [[NSFileManager defaultManager] removeItemAtURL:path error:nil];
    RLMRealm *realm = [RLMRealm realmWithURL:path];
*/
    
    // default db
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:person1];
    [realm addObject:person2];
    [realm commitWriteTransaction];
}

- (void)queryDataFromRealm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults<Engineer *> *results = [Engineer objectsInRealm:realm where:@"age > 20"];
    
    for (int i = 0; i < results.count; ++i) {
        NSLog(@"[RLMRealm]name = %@, age = %@", ((Engineer*)[results objectAtIndex:i]).name,((Engineer*)[results objectAtIndex:i]).age);
    }
}

- (void)updateDataInRealm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults<Engineer *> *results = [Engineer allObjects];
    [realm transactionWithBlock:^{
        [results setValue:@"22" forKeyPath:@"age"];
    }];
    
    [realm beginWriteTransaction];
    results.firstObject.name = @"Xcode";
    [realm commitWriteTransaction];
}

- (void)deleteDatafromRealm {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults <Engineer *> *results = [Engineer objectsInRealm:realm where:@"age > 0"];
    [realm beginWriteTransaction];
    [realm deleteObject:results.firstObject];
    [realm commitWriteTransaction];
}

#pragma mark - UIPasteboard Operation

// A pasteboard is a named region of memory where data can be shared
// A pasteboard must be identified by a unique name
// When you write an object to a pasteboard, it is stored as a pasteboard item. A pasteboard item is one or more key-value pairs where the key is a string that identifies the representation type of the value.
- (void)insertDataIntoPasteboard {
//    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"com.forwardto9.iOSDBDemo" create:YES];
//    pasteboard.persistent    = YES;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // When users restart a device, the change count is reset to zero.
    NSLog(@"generalPasteboard property: persistent = %d, name = %@, changeCount = %ld", pasteboard.persistent, pasteboard.name, (long)pasteboard.changeCount);
    
    // Calling this method replaces any items currently in the pasteboard.
    // 将数字保存到剪切板中，就会遇到反解的问题，暂定是bug
    [pasteboard setValue:@"123" forPasteboardType:@"com.uwei.Int"];
    NSLog(@"generalPasteboard property: persistent = %d, name = %@, changeCount = %ld", pasteboard.persistent, pasteboard.name, (long)pasteboard.changeCount);
    [pasteboard addItems:@[@{@"key1":@"value1"}]];
    [pasteboard addItems:@[@{@"key2":@"value2"}]];
    [pasteboard addItems:@[@{@"key3":@"value3"}]];
}

- (void)deleteDataFromPasteboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.items = [NSArray array];
}

- (void)queryDataFromPasteboard {
//    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"com.forwardto9.iOSDBDemo" create:YES];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // this code is not working
//    id value = [pasteboard valueForPasteboardType:@"com.uwei.Int"];
//    NSLog(@"[Pasteboard]value is %@", value);
    NSArray *items = [pasteboard items];
    if (items.count > 0) {
        NSLog(@"[Pasteboard] exits datas");
    } else {
        NSLog(@"[Pasteboard] not exits datas");
    }
    for (int i = 0; i < items.count; ++i) {
        id obj = items[i];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSData *data = [(NSDictionary *)obj allValues][0];
//            if (i == 0) {
//                NSValue *value = [NSValue valueWithBytes:data.bytes objCType:@encode(NSInteger)];
//                int x = 0;
//                [value getValue:&x];
//                const char * bytes = [data bytes];
//                int num = atoi(bytes);
//                NSLog(@"Item:%@ = %d", [(NSDictionary *)obj allKeys][0], num);
//            } else {
//                NSString *str = [NSString stringWithCString:data.bytes encoding:NSUTF8StringEncoding];
//                NSLog(@"Item:%@ = %@", [(NSDictionary *)obj allKeys][0], str);
//            }
            id str = [NSString stringWithCString:data.bytes encoding:NSUTF8StringEncoding];
            NSLog(@"[Pasteboard] Item:%@ = %@", [(NSDictionary *)obj allKeys][0], str);
        }
    }
}

- (void)updateDataFromPasteboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if ([pasteboard containsPasteboardTypes:@[@"com.uwei.Int"] inItemSet:nil]) {
        NSLog(@"[Pasteboard] find!");
        [pasteboard setValue:@"321" forPasteboardType:@"com.uwei.Int"];
        NSLog(@"[Pasteboard] updated!");
    } else {
        NSLog(@"[Pasteboard] not find!");
    }
}

#pragma mark - iCloud
- (BOOL)connectToiCloud {
    CKContainer *shareContainer = [CKContainer containerWithIdentifier:@"iCloud.com.tencent.teg.demo"];
    self.ckPublicDataBase = shareContainer.publicCloudDatabase;
    self.ckPrivateDataBase = shareContainer.privateCloudDatabase;
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"No account" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    
    return (self.ckPrivateDataBase && self.ckPublicDataBase != nil);
}

- (void)insertiCloudData {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"1010"];
    CKRecord *record     = [[CKRecord alloc] initWithRecordType:@"Person" recordID:recordID];
    record[@"name"] = @"uwei";
    record[@"age"]  = @29;
    [self.ckPublicDataBase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"save data to icloud failed:%@", error.localizedDescription);
        } else {
            NSLog(@"save data to icloud done!");
        }
    }];
}

- (void)queryiCloudData {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"1010"];
    [self.ckPublicDataBase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Fetch data from icloud failed:%@", error.localizedDescription);
        } else {
            NSLog(@"data is %@", record);
        }
    }];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"age > %d", 20];
    CKQuery *fetchQuery = [[CKQuery alloc] initWithRecordType:@"Person" predicate:fetchPredicate];
    [self.ckPublicDataBase performQuery:fetchQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Fetch data by using CKQuery from icloud failed:%@ ", error.localizedDescription);
        } else {
            NSLog(@"result is %@", results);
        }
    }];
}

- (void)updateiCloudData {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"1010"];
    [self.ckPublicDataBase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"update data from icloud failed:%@", error.localizedDescription);
        } else {
            record[@"name"] = @"test";
            [self.ckPublicDataBase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                if (error) {
                    //
                    NSLog(@"update data from icloud failed:%@", error.localizedDescription);
                } else {
                    NSLog(@"update data from icloud done");
                }
            }];
        }
    }];
}

- (void)deleteiCloudData {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"1010"];
    [self.ckPublicDataBase deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (error) {
            NSLog(@"delete record failed:%@", error.localizedDescription);
        } else {
            NSLog(@"delete record OK");
        }
    }];
}


- (void)subscribeiCloud {
//    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"1010"];
    NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"name = %@", @"uwei"];
    CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"Person" predicate:subPredicate options:CKSubscriptionOptionsFiresOnRecordUpdate];
    CKNotificationInfo *nInfo = [CKNotificationInfo new];
//    nInfo.alertLocalizationKey = @"my alert key";
    nInfo.alertBody = @"this message is from icloud";
    nInfo.desiredKeys = @[@"name", @"age"];
    nInfo.shouldBadge = YES;
    subscription.notificationInfo = nInfo;
    [self.ckPublicDataBase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
        if (error) {
            NSLog(@"save subscription error:%@", error.localizedDescription);
        } else {
            NSLog(@"save subscription OK");
        }
    }];
}


@end
