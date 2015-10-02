//
//  MoviesViewController.m
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import "MoviesViewController.h"
#import "Movies.h"
#import "Categories.h"

@interface MoviesViewController ()
@property (nonatomic, retain) NSArray *movies;
@property (nonatomic, retain) NSArray *categories;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"My movies";
    [self createContext];
    [self loadCategories];
    
    self.categories = [self fetchCategories];
    self.movies = [self fetchMovies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Database operations
- (void) createContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];

}

#pragma mark - Load default data
- (void) loadCategories {
    NSArray *categories = [self fetchCategories];
    //if empty add the default ones
    if ([categories count] == 0 ) {
        [self createCategoryWithName:@"Action" AndId:0];
        [self createCategoryWithName:@"History" AndId:1];
        [self createCategoryWithName:@"Animated" AndId:2];
        [self createCategoryWithName:@"Suspense" AndId:3];
        [self createCategoryWithName:@"Terror" AndId:4];
    }

}

- (NSArray*) fetchCategories {
    //Get data, remember to assign a NSManagedObject in the view controller
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Categories" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *categories = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return categories;
}

- (void) createCategoryWithName: (NSString*) name AndId: (NSInteger) idNumber {
    //Insert categories
    Categories *category = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Categories"
                            inManagedObjectContext:self.managedObjectContext];
    category.name = name;
    category.id =  [NSNumber numberWithInteger:idNumber] ;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray*) fetchMovies {
    //Get data, remember to assign a NSManagedObject in the view controller
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Movies" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *movies = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return movies;
}



@end
