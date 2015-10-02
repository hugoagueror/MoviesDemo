//
//  AddMovieViewController.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddMovieDelegate <NSObject>
@optional
- (void) userHasAddedMovie;

@end

@interface AddMovieViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate>

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic , strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic , retain) id <AddMovieDelegate> delegate ;

@end
