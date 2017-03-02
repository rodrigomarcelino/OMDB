//
//  SavedViewController.m
//  
//
//  Created by Zup Mac Pro on 1/30/17.
//
//

#import "SavedViewController.h"
#import "FilmCell.h"
#import "SavedDetailsViewController.h"

@interface SavedViewController ()

@end

@implementation SavedViewController

#pragma mark - Load saved films cells

-(void)viewDidAppear:(BOOL)animated{
  [_mTableView reloadData];//Update table View whenever you open the screen
}

- (void)viewDidLoad {
    [super viewDidLoad];
   tableDataArray = [[RLMFilm allObjects] sortedResultsUsingDescriptors:@[
  [RLMSortDescriptor sortDescriptorWithProperty:@"title" ascending:YES]
                                                                         ]];
  //tableDataArray=[RLMFilm allObjects];//Get all objects stored in realm
  [_mTableView reloadData];//Update Table View
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Manager the number of sections in the application
  NSInteger numOfSections = 0;
  if ([tableDataArray count] > 0)
  {
    //Show cells
    //_mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    numOfSections                = 1;
    _mTableView.backgroundView = nil;
  }
  else
  {
    //Show message
    UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mTableView.bounds.size.width, _mTableView.bounds.size.height)];
    noDataLabel.text             = @"Please add Favorites into Search";
    noDataLabel.textColor        = [UIColor blackColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    _mTableView.backgroundView = noDataLabel;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
  
  return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [tableDataArray count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;//
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  //Manager the swipe for delete
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    //Delete in realm
    RLMFilm *information = [tableDataArray objectAtIndex:indexPath.row];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:information];
    [realm commitWriteTransaction];
    //
    [_mTableView reloadData];
  }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Shows the cells that are in realm
  FilmCell *cell = (FilmCell *)[tableView dequeueReusableCellWithIdentifier:@"FilmCell"];
  RLMFilm *information = [tableDataArray objectAtIndex:indexPath.row];
  cell.title.text = information.title;
  cell.year.text=information.year;
  cell.poster.image = [UIImage imageWithData:information.poster];
  cell.poster.contentMode = UIViewContentModeScaleAspectFit;
  return cell;
}

- (IBAction)deleteFilm{
  //Delete selected film
  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  RLMFilm *information = [tableDataArray objectAtIndex:indexPath.row];
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  [realm deleteObject:information];
  [realm commitWriteTransaction];
  [_mTableView reloadData];
}

#pragma mark - Send informations to details

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SavedDetais"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SavedDetailsViewController *destViewController = segue.destinationViewController;
    RLMFilm *information = [tableDataArray objectAtIndex:indexPath.row];
    destViewController.title = information.title;
    destViewController.year = information.year;
    destViewController.imdbRating = information.imdbRating;
    destViewController.poster = information.poster;
    destViewController.director = information.director;
    destViewController.genre = information.genre;
    destViewController.plot = information.plot;
    destViewController.runtime = information.runtime;
    destViewController.father = self;
  }
}
@end
