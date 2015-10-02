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
#import "MovieTableViewCell.h"

@interface MoviesViewController ()
@property (nonatomic, retain) NSArray *movies;
@property (nonatomic, retain) NSArray *categories;
@property (weak, nonatomic) IBOutlet UITableView *tvMovies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"My movies";
    self.tvMovies.delegate = self ;
    self.tvMovies.dataSource = self ;
    
    //
    [self createContext];
    [self loadCategories];
    
    self.categories = [self fetchCategories];
    self.movies = [self fetchMovies];
    [self.tvMovies reloadData];
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

- (Categories*) getCategoryWithId:(NSNumber*) MovieId{
    //Filter the category array
    
    NSPredicate *pred ;
    pred =[NSPredicate predicateWithFormat:@"(id == [c] %@)" , MovieId  ];
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"numericValue" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject: sort];
    
    NSArray *filteredArr = [[self.categories filteredArrayUsingPredicate:pred] sortedArrayUsingDescriptors:sortDescriptors];
    
    if ([filteredArr count] >= 1){
        return [filteredArr objectAtIndex:0];
    }else {
        NSLog(@"Unexpected id. Row should have one of the stored categories ");
        return nil;
    }
    
}

#pragma mark - UITableDataSourceDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    
    Movies *movie = [self.movies objectAtIndex:indexPath.row];
    Categories *category = [self  getCategoryWithId:movie.category ];
    //fill labels
    cell.lblName.text = [NSString stringWithFormat:@"Name: %@", movie.name];
    cell.lblCategory.text = [NSString stringWithFormat:@"Category: %@", category.name ];
    
    //set up rating
    cell.starRating.starImage = [UIImage imageNamed:@"starImage"];
    cell.starRating.starHighlightedImage = [UIImage imageNamed:@"starImageHighlighted"];
    cell.starRating.maxRating = 5.0;
    cell.starRating.displayMode = EDStarRatingDisplayFull;
    cell.starRating.editable = NO ;
    cell.backgroundColor = [UIColor clearColor];
    
    //assign score value
    cell.starRating.rating = [movie.score integerValue];
    
    return cell;
}


@end
