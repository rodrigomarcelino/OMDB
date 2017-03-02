//
//  SavedDetailsViewController.h
//  OMDB
//
//  Created by Zup Mac Pro on 2/2/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedViewController.h"
#import "NYTPhotosViewController.h"
#import "NYTPhotoModel.h"

@interface SavedDetailsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong)  SavedViewController *father;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *year;
@property(nonatomic, strong) NSString *rated;
@property(nonatomic, strong) NSString *runtime;
@property(nonatomic, strong) NSString *genre;
@property(nonatomic, strong) NSString *director;
@property(nonatomic, strong) NSString *plot;
@property(nonatomic, strong) NSString *posterURL;
@property(nonatomic, strong) NSData *poster;
@property(nonatomic, strong) NSString *imdbRating;
@property(nonatomic, strong) NSString *imdbID;
@property(nonatomic, strong) NSString *type;
- (IBAction)deleteFilm:(id)sender;//call father deletefilm

@end
