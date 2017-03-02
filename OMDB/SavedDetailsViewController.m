//
//  SavedDetailsViewController.m
//  OMDB
//
//  Created by Zup Mac Pro on 2/2/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import "SavedDetailsViewController.h"

@interface SavedDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) NSArray *photos;


@end

@implementation SavedDetailsViewController
@synthesize title, year, rated, runtime, genre, director, plot, poster, imdbRating, imdbID, type;

#pragma mark - Load film

- (void)viewDidLoad {
    [super viewDidLoad];
    
  _titleLabel.text = title;
  _yearLabel.text = year;
  _ratingLabel.text = imdbRating;
  _posterImageView.image =[UIImage imageWithData: poster];;
  _directorLabel.text = director;
  _genreLabel.text= genre;
  _plotLabel.text =plot;
  _runtimeLabel.text = runtime;
  _typeLabel.text = type;
  _posterImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Open poster image details

- (IBAction)imageButtonTapped:(id)sender {
  UIImage *image = [UIImage imageWithData: poster];
  self.photos = [[self class] newTestPhotosWithPoster:image :title :director];
  NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:_photos  initialPhoto:nil delegate:self];
  [self presentViewController:photosViewController animated:YES completion:nil];
}

+ (NSArray *)newTestPhotosWithPoster:(UIImage*) image :(NSString*) title: (NSString*) director{
  NSMutableArray *photos = [NSMutableArray array];
  NYTPhotoModel *photo = [[NYTPhotoModel alloc] init];
  photo.image = image;
  
  NSString *caption = title;
  NSString* credit = director;
  photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
  photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:caption attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
  photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:credit attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
  
  [photos addObject:photo];
  
  return photos;
}

#pragma mark - Delete Film

- (IBAction)deleteFilm:(id)sender {
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"Delete Film"
                                message:@"You want delete the film?"
                                preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                   [_father deleteFilm];//Call father deleteFilm
                                                   [self back];
                                                 }];
  UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                 }];
  
  [alert addAction:cancel];
  [alert addAction:delete];
  
  [self presentViewController:alert animated:YES completion:nil];
}
-(void) back{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
