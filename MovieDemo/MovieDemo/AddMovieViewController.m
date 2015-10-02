//
//  AddMovieViewController.m
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import "AddMovieViewController.h"

@interface AddMovieViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMovieName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategories;

@end

@implementation AddMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fillCategories];
}

- (void) fillCategories {
    
}


@end
