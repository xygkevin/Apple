//
//  Book+CoreDataProperties.h
//  iOSDBDemo
//
//  Created by uwei on 8/31/16.
//  Copyright © 2016 forwardto9. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *pageCount;
@property (nullable, nonatomic, retain) NSDate *copyright;
@property (nullable, nonatomic, retain) NSString *author;

@end

NS_ASSUME_NONNULL_END
