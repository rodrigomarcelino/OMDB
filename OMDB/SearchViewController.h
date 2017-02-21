//
//  SearchViewController.h
//  OMDB
//
//  Created by Zup Mac Pro on 1/20/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Film.h"
#import <MBProgressHUD.h>

@interface SearchViewController : UITableViewController <UISearchBarDelegate,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *films;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property NSString *search;
@property (nonatomic) int currentPage;
@property (nonatomic) int totalPages;
@property (nonatomic) int totalResults;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) MBProgressHUD *hud;//Manager the loading
@property (strong, nonatomic) UIImage *imageFromSearchResult;


@end
