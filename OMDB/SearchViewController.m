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
  //exchange every "space" for "+"
  NSString *str = [searchBar.text stringByReplacingOccurrencesOfString:@" "
                                                            withString:@"+"];
  NSLog(@"\n\nString New:%@",str);
  _search = str;
  //Network:
  NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json",str];
  
   NSURL *URL = [NSURL URLWithString:link];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
      UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"An error has occurred!"
                                    message:@"Please check your internet connection."
                                    preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                 }];
      
      [alert addAction:Ok];
      [self presentViewController:alert animated:YES completion:nil];
      
    } else {
     self.actualPage = 1;
     // NSLog(@"\n\nfilms:%@", responseObject);
      films = [[NSMutableArray alloc]init];
      NSDictionary *resultDictinary = [responseObject objectForKey:@"Search"];
      int totalResults = [[responseObject objectForKey:@"totalResults"] intValue];
      _totalPages = ceil(totalResults/10);
      NSLog(@"\n%@",responseObject);
      for (NSDictionary *filmDictionary in resultDictinary)
      {
        Film *newFilm=[[Film alloc]initWithDictionary:filmDictionary];
        [films addObject:newFilm];
      }
      if(films.count == 0){
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mTableView.bounds.size.width, _mTableView.bounds.size.height)];
        noDataLabel.text             = @"No results";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
      }else{
        _mTableView.backgroundView = nil;
        
      }
      [_mTableView reloadData];
      [_hud hideAnimated:NO];
      [_hud showAnimated:NO];
    }
  }
       failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }];
  //Show Loading:
  _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  _hud.label.text = @"Loading";
  [_hud hideAnimated:YES];
  [_hud showAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
  NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
  if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
    //Network:
    self.actualPage += 1;
    if(_actualPage<=_totalPages){
      NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&page=%d",_search,_actualPage];
      NSURL *URL = [NSURL URLWithString:link];
      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      
      [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
          UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"An error has occurred!"
                                        message:@"Please check your internet connection."
                                        preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
          
          [alert addAction:Ok];
          [self presentViewController:alert animated:YES completion:nil];
          
        } else {
          NSDictionary *resultDictinary = [responseObject objectForKey:@"Search"];
          for (NSDictionary *filmDictionary in resultDictinary)
          {
            Film *newFilm=[[Film alloc]initWithDictionary:filmDictionary];
            [films addObject:newFilm];
          }
          if(films.count == 0){
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mTableView.bounds.size.width, _mTableView.bounds.size.height)];
            noDataLabel.text             = @"No results";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Incorrect name!"
                                          message:@"No results."
                                          preferredStyle:UIAlertControllerStyleAlert];
          }else{
            _mTableView.backgroundView = nil;
            
          }
          [_mTableView reloadData];
          [_hud hideAnimated:NO];
          [_hud showAnimated:NO];
        }
      }
           failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailsViewController *destViewController = segue.destinationViewController;
    Film *film = (self.films)[indexPath.row];
    destViewController.imdbID = film.imdbID;
  }
}

@end
