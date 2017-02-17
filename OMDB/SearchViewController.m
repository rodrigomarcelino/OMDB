//
//  SearchViewController.m
//  OMDB
//
//  Created by Zup Mac Pro on 1/20/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import "SearchViewController.h"
#import "FilmCell.h"
#import "AFNetworking.h"
#import "DetailsViewController.h"
#import "SavedViewController.h"
#import "FilmManager.h"


@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize films;
@synthesize mSearchBar;

- (void)viewDidLoad {
  [super viewDidLoad];
  mSearchBar.delegate = self;//Delegate data
  self.mSearchBar.placeholder = @"Search films";
  self.actualPage = 0;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.films.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  FilmCell *cell = (FilmCell *)[tableView dequeueReusableCellWithIdentifier:@"FilmCell"];
  Film *film = (self.films)[indexPath.row];
  NSLog(@"\n%@",film.title);
  cell.title.text = film.title;
  cell.year.text = film.year;
  if([film.posterURL  isEqualToString:@"N/A"])  {
    // If the film has no picture add not-found image
    cell.poster.image = [UIImage imageNamed:@"not-found.png"];
  }else{
    //exchang every "http:" for "https:"
    NSString *str = [film.posterURL stringByReplacingOccurrencesOfString:@"http:"
                                                              withString:@"https:"];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:str]];
    cell.poster.image = [UIImage imageWithData: imageData];
    cell.poster.contentMode = UIViewContentModeScaleAspectFit;
  }
  return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  mSearchBar.showsCancelButton = true;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  
  [mSearchBar resignFirstResponder];
  [[FilmManager sharedInstance] getFilmWithName:self.mSearchBar.text ?: @"" success:^(NSMutableArray* films1) {
    
    NSLog(@"25\n%@",films1);
    films = films1;
    [_mTableView reloadData];;
    
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  
      [_mTableView reloadData];
      [_hud hideAnimated:NO];
      [_hud showAnimated:NO];
  //Show Loading:1
 // _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  //_hud.label.text = @"Loading";
  //[_hud hideAnimated:YES];
  //[_hud showAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
  NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
  if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
    //Network:
    self.actualPage += 1;
    if(_actualPage<=_totalPages){
     // films = [[FilmManager sharedInstance]getFilmWithName:self.mSearchBar.text ?: @"" ];
      NSLog(@"3\n%@",films);
          [_mTableView reloadData];
          [_hud hideAnimated:NO];
          [_hud showAnimated:NO];

      //Show Loading:
      _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
      _hud.label.text = @"Loading";
      [_hud hideAnimated:YES];
      [_hud showAnimated:YES];
    }
  }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [searchBar resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  //Transfer your information for next screen
  if ([segue.identifier isEqualToString:@"ShowDetails"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailsViewController *destViewController = segue.destinationViewController;
    Film *film = (self.films)[indexPath.row];
    destViewController.imdbID = film.imdbID;
  }
}

@end
