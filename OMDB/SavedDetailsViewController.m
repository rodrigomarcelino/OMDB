//
//  SavedDetailsViewController.m
//  OMDB
//
//  Created by Zup Mac Pro on 2/2/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import "SavedDetailsViewController.h"

@interface SavedDetailsViewController ()

@end

@implementation SavedDetailsViewController
@synthesize title, year, rated, runtime, genre, director, plot, poster, imdbRating, imdbID, type;
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

#pragma mark - Table view data source

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
