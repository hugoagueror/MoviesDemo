//
//  MoviesViewController.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMovieViewController.h"
#import "MovieDetailsViewController.h"

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddMovieDelegate, MovieDetailsDelegate>

@property (nonatomic , strong) NSManagedObjectContext *managedObjectContext;



@end
