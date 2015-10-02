//
//  MovieDetailsViewController.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movies.h"

@protocol MovieDetailsDelegate <NSObject>

- (void) userSavedRating ;

@end

@interface MovieDetailsViewController : UIViewController

@property (nonatomic , retain) Movies *movie; //selected movie to show
@property (nonatomic, retain) NSString *category ;
@property (nonatomic , strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic , retain) id <MovieDetailsDelegate> delegate;

@end
