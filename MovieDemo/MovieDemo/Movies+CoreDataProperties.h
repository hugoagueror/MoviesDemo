//
//  Movies+CoreDataProperties.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movies.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movies (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSNumber *numberOfCalifications;

@end

NS_ASSUME_NONNULL_END
