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
#import "AddMovieViewController.h"
#import "MovieDetailsViewController.h"

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
    //Add button to Nav Controller
    [self addButtonToNavController];
    //
    [self createContext];
    [self loadCategories];
    
    self.categories = [self fetchCategories];
    self.movies = [self fetchMovies];
    
}

#pragma mark - Add Button to Nav Controller
- (void) addButtonToNavController {
    UIBarButtonItem *addMovieButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddMoviePopViewController:)];
    
    self.navigationItem.rightBarButtonItem  = addMovieButton;
}

//Shows the add movie popup
- (void) showAddMoviePopViewController:(UIBarButtonItem*) button {
    AddMovieViewController *addMovieVC = (AddMovieViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"AddMovieViewController"] ;
    addMovieVC.categories = self.categories;
    addMovieVC.delegate =  self ;
    
    [addMovieVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [addMovieVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:addMovieVC animated:YES completion:nil];
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
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sort];
    fetchRequest.sortDescriptors = sortDescriptors;
    
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
    
    NSLog(@"Creation date for %@  movie is %@" , movie.name , movie.creationDate );
    
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
#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movies *selectedMovie = [self.movies objectAtIndex:indexPath.row];
    Categories *category = [self  getCategoryWithId:selectedMovie.category ];
    
    MovieDetailsViewController *movieDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetailsViewController"];
    movieDetailVC.movie = selectedMovie ;
    movieDetailVC.category =  category.name;
    movieDetailVC.delegate = self ;
    
    [self.navigationController pushViewController:movieDetailVC animated:YES];
}


#pragma mark - Add Movie Delegate

- (void) userHasAddedMovie {
    self.movies = [self fetchMovies];
    [self.tvMovies reloadData];
}

- (void) userSavedRating {
    self.movies = [self fetchMovies];
    [self.tvMovies reloadData];
}


@end
