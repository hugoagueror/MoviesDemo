//
//  MoviesViewController.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMovieViewController.h"

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddMovieDelegate>

@property (nonatomic , strong) NSManagedObjectContext *managedObjectContext;



@end
