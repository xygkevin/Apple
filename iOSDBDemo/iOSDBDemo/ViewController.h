//
//  ViewController.h
//  iOSDBDemo
//
//  Created by forwardto9 on 16/8/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (strong,  nonatomic) NSManagedObjectContext *managedObjectContext;

@end

