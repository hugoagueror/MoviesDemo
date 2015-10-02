//
//  AddMovieViewController.m
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import "AddMovieViewController.h"
#import "Categories.h"

@interface AddMovieViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMovieName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategories;
@property (nonatomic, retain) Categories *selectedCategory ;

@end

@implementation AddMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickerCategories.delegate = self;
    self.pickerCategories.dataSource = self ;
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  [self.categories count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Categories *category =  [self.categories objectAtIndex:row];
    return  category.name ;
}


#pragma mark - UIPickerViewDelegate

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategory = [self.categories objectAtIndex:row];
}


@end
