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
  self.currentPage = 0;
  self.TableView.estimatedRowHeight = 110.0; // for example. Set your average height
  self.TableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)TableView numberOfRowsInSection:(NSInteger)section {
  if(self.films.count==0){
    _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  }
  return self.films.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FilmCell *cell = (FilmCell *)[tableView dequeueReusableCellWithIdentifier:@"FilmCell"];
  Film *film = (self.films)[indexPath.row];
  NSLog(@"\n%@",film.title);
  cell.title.text = film.title;
  cell.year.text = film.year;
    cell.poster.image = [[FilmManager sharedInstance] imageForKey:film.imdbID];
    cell.poster.contentMode = UIViewContentModeScaleAspectFit;
  _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Do some stuff when the row is selected
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
  //exchange every "space" for "+"
  NSString *str = [mSearchBar.text stringByReplacingOccurrencesOfString:@" "
                                                   withString:@"+"];
  _search = str;
  //Show Loading:
  _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  _hud.label.text = @"Loading";
  [_hud hideAnimated:YES];
  [_hud showAnimated:YES];
  [[FilmManager sharedInstance] getFilmWithName:self.mSearchBar.text ?: @"" success:^(NSMutableArray* films1, int totalpages) {
    if(totalpages == 0){
      [self alert];
      films = films1;
      [self.TableView reloadData];
      [_hud hideAnimated:NO];
      [_hud showAnimated:NO];
    }else{
    films = films1;
    _totalPages = totalpages;
    self.currentPage = 1;
    [self.TableView reloadData];
    [_hud hideAnimated:NO];
    [_hud showAnimated:NO];
    }
    
  }failure:^(NSError *error) {
    [self errorAlert];
  }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
  NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
  if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
    //Network:
    self.currentPage += 1;
    if(_currentPage<=_totalPages){
      [[FilmManager sharedInstance] getFilmWithPage:_search :_currentPage success:^(NSMutableArray* films1){
        int i = films1.count;
        for(int j=0;j<i;j++){
        [films addObject:films1[j]];
        }
          [self.TableView reloadData];
          [_hud hideAnimated:NO];
          [_hud showAnimated:NO];
      } failure:^(NSError *error) {
        [self errorAlert];
      }];

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
    NSIndexPath *indexPath = [self.TableView indexPathForSelectedRow];
    DetailsViewController *destViewController = segue.destinationViewController;
    Film *film = (self.films)[indexPath.row];
    destViewController.imdbID = film.imdbID;
  }
}

-(void) errorAlert{
  //Show
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"An error has occurred!"
                                message:@"Please check your internet connection."
                                preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action){
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
  [alert addAction:Ok];
  [self presentViewController:alert animated:YES completion:nil];
  
}

-(void) alert{
  //Show
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"An error has occurred!"
                                message:@"Please check the film name."
                                preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action){
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
  [alert addAction:Ok];
  [self presentViewController:alert animated:YES completion:nil];
  
}
@end
