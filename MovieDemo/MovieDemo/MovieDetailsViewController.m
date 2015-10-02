//
//  MovieDetailsViewController.m
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import  "EDStarRating.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblMovieName;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfCalifications;
@property (weak, nonatomic) IBOutlet EDStarRating *starRating;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Movie Details";
    [self fillData];
    [self createContext];
}



- (void) fillData {
    self.lblMovieName.text = self.movie.name ;
    self.lblCategory.text = self.category ;
    self.lblNumberOfCalifications.text = [NSString stringWithFormat:@"Number of califications: %ld", [self.movie.numberOfCalifications integerValue] ];
    
    self.starRating.starImage = [UIImage imageNamed:@"starImage"];
    self.starRating.starHighlightedImage = [UIImage imageNamed:@"starImageHighlighted"];
    self.starRating.maxRating = 5.0;
    self.starRating.displayMode = EDStarRatingDisplayFull;
    self.starRating.editable = YES ;
    self.starRating.backgroundColor = [UIColor clearColor];
    self.starRating.rating = [self.movie.score integerValue];
}


- (IBAction)btnSaveRating:(id)sender {
    [self saveRating];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Database operations
- (void) createContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
}
- (void) saveRating {
    
    self.movie.score = [NSNumber numberWithInt:self.starRating.rating ]  ;
    self.movie.numberOfCalifications =  [NSNumber numberWithInteger: [self.movie.numberOfCalifications integerValue] + 1 ]   ;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else {
        [self.delegate userSavedRating];
    }
}



@end
