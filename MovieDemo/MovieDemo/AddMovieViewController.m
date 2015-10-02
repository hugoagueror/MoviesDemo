//
//  AddMovieViewController.m
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import "AddMovieViewController.h"
#import "Categories.h"
#import  "Movies.h"

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
    [self addGesture];
    [self createContext];
    
}

#pragma mark - End edit Gesture
- (void) addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
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

#pragma mark - Helpers
- (BOOL) isValid{
    BOOL isValid = YES;
    if ([self.txtMovieName.text isEqualToString:@""]){
        isValid = NO ;
    }
    
    if (self.selectedCategory == nil){
        isValid = NO ;
    }
    return isValid ;
}

#pragma mark - Touch Actions

- (IBAction)btnCancelTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSaveMovieTouched:(id)sender {
    if ([self isValid]){
        [self saveMovieInDb];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Database operations
- (void) createContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
}

- (void) saveMovieInDb {
    Movies *movie = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Movies"
                     inManagedObjectContext:self.managedObjectContext];
    movie.name = self.txtMovieName.text;
    movie.score = [NSNumber numberWithInt:0]  ;
    movie.category =  [self.selectedCategory id ];
    movie.creationDate = [NSDate date];
    movie.numberOfCalifications = 0;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else {
        [self.delegate userHasAddedMovie];
    }
}


@end
