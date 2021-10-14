//
//  AppDelegate.m
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "ViewController.h"
@interface AppDelegate ()

/**
 @desc 操作数据库必须的上下文，在CoreData中对数据的所有操作都必须基于上下文.
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 @desc 指定开发者自己创建的模型文件，即工程中以xcdatamodeld为后缀的文件，但是这个文件将在编译时被修改为以momd为后缀的文件.这个文件在保存的目录下.
 */
@property (strong, nonatomic) NSManagedObjectModel   *managedObjectModel;

/**
 @desc 数据库文件的连接器
 */
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


/**
 NSEntityDescription 这个类用来指定要访问的数据库中的表， 对应着xcdatamodeld文件中的Entity.
 NSFetchRequset      这个类用来封装查询语句，可以通过设置其属性来实现类似SQL的条件查询，重要的有offset, limit, predicate(NSPredicate 对象)
 NSManagedObject     这个类是用来封装要保存到数据库表中的数据的抽象，Fetch出来的对象都是此类型.
 */


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%@", [[self.window.rootViewController class] description]);
    
    if ([self.window.rootViewController isKindOfClass:[ViewController class]]) {
        ((ViewController *)self.window.rootViewController).managedObjectContext = self.managedObjectContext;
    }
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:notificationSettings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
    NSString *body = cloudKitNotification.alertBody;
    NSString *key = cloudKitNotification.alertLocalizationKey;
    NSLog(@"key = %@, body = %@", key, body);
    if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
        NSLog(@"record is %@", [(CKQueryNotification *)cloudKitNotification recordID]);
    }
}


- (void)saveContext {
    NSError *error = nil;
    if (_managedObjectContext) {
        if ([_managedObjectContext hasChanges] && [_managedObjectContext save:&error]) {
            NSLog(@"Save managed object context failed! error info:%@", [error localizedDescription]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:(NSMainQueueConcurrencyType)];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"book.store"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // copy sql file in bundle to local file
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError *error = nil;
    if (!([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])) {
        NSLog(@"Create store failed! error info:%@", [error localizedDescription]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelFileURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelFileURL];
    
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
