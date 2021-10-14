//
//  AppDelegate.m
//  iOSPrivateAPIDemo
//
//  Created by uwei on 9/29/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+PropertyList.h"
#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self getAppPlist];
    return YES;
}


-(void)getAppPlist
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    NSArray*apps = [workspace performSelector:@selector(allApplications)];
    
    NSMutableArray*appsIconArr = [NSMutableArray array];
    
    NSMutableArray*appsNameArr = [NSMutableArray array];
    
    NSLog(@"apps: %@",apps );
    
    [apps enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL* stop) {
        
        NSDictionary*boundIconsDictionary = [obj performSelector:@selector(boundIconsDictionary)];
        
        NSString*iconPath = [NSString stringWithFormat:@"%@/%@.png", [[obj performSelector:@selector(resourcesDirectoryURL)]path], [[[boundIconsDictionary objectForKey:@"CFBundlePrimaryIcon"]objectForKey:@"CFBundleIconFiles"]lastObject]];
        
        
        UIImage*image = [[UIImage alloc]initWithContentsOfFile:iconPath];
        
        id name = [obj performSelector:@selector(localizedName)];
        
        if(image)
            
        {
            
            [appsIconArr addObject:image];
            
            [appsNameArr addObject: name];
            
        }
        
        
        NSLog(@"iconPath = %@", iconPath);
        
        NSLog(@"name = %@", name);
        
        NSLog(@"%@",[obj properties_aps]);
        
        NSLog(@"_____________________________________________\n");
    }];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
