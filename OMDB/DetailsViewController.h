//
//  DetailsViewController.h
//  
//
//  Created by Zup Mac Pro on 1/30/17.
//
//

#import <UIKit/UIKit.h>
#import "Film.h"
#import <MBProgressHUD.h>

@interface DetailsViewController : UITableViewController

@property (nonatomic, strong) NSString *imdbID;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;
@property (weak, nonatomic) IBOutlet UILabel *imdbRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic,strong) Film *film;
@property (nonatomic, retain) MBProgressHUD *hud;

@end
