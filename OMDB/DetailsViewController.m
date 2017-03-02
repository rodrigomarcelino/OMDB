//
//  DetailsViewController.m
//  
//
//  Created by Zup Mac Pro on 1/30/17.
//
//

#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "RLMFilm.h"
#import "FilmManager.h"
#import "NYTPhoto.h"

typedef NS_ENUM(NSUInteger, NYTViewControllerPhotoIndex) {
  NYTViewControllerPhotoIndexCustomEverything = 1,
  NYTViewControllerPhotoIndexLongCaption = 2,
  NYTViewControllerPhotoIndexDefaultLoadingSpinner = 3,
  NYTViewControllerPhotoIndexNoReferenceView = 4,
  NYTViewControllerPhotoIndexCustomMaxZoomScale = 5,
  NYTViewControllerPhotoIndexGif = 6,
  NYTViewControllerPhotoCount,
};


@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) NSArray *photos;

@end

@implementation DetailsViewController
@synthesize imdbID;
@synthesize film;

- (void)viewDidLoad {
    [super viewDidLoad];
  NSLog(@"\n\nID: %@\n\n", imdbID);
  [[FilmManager sharedInstance] getFilmWithID:imdbID success:^(Film* f) {
    if (f==NULL) {
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
      film = f;
      NSLog(@"\n\nfilms:%@", self.film);
      self.titleLabel.text = self.film.title;
      self.yearLabel.text = self.film.year;
      self.runtimeLabel.text = self.film.runtime;
      self.ratedLabel.text = self.film.rated;
      self.genreLabel.text = self.film.genre;
      self.directorLabel.text = self.film.director;
      self.plotLabel.text = self.film.plot;
      self.typeLabel.text = self.film.type;
      self.imdbRatingLabel.text = self.film.imdbRating;
      //Get not-found image:
      if([self.film.posterURL isEqualToString:@"N/A"]){
        NSString *str = @"https://filmesonlinegratis.club/uploads/posts/2016-06/1466777116_1459367668_no_poster.png";
        self.film.poster = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:str]];
      }else{
        NSString *str = [self.film.posterURL stringByReplacingOccurrencesOfString:@"http:"
                                                                       withString:@"https:"];
        self.film.poster = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:str]];
      }
      self.posterImageView.image = [UIImage imageWithData: self.film.poster];
      _posterImageView.contentMode = UIViewContentModeScaleAspectFit;
      [_hud hideAnimated:NO];
      [_hud showAnimated:NO];
    }
  }
    failure:^(NSError *error) {
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"An error has occurred!"
                                  message:@"Please check your internet connection."
                                  preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  }];
                                        
     [alert addAction:Ok];
     [self presentViewController:alert animated:YES completion:nil];
     }];
  //Show loading
  _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  _hud.label.text = @"Loading";
  [_hud hideAnimated:YES];
  [_hud showAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 }

- (IBAction)imageButtonTapped:(id)sender {
  
  self.photos = [[self class] newTestPhotosWithPoster:film];
  NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:_photos  initialPhoto:nil delegate:self];
  [self presentViewController:photosViewController animated:YES completion:nil];
}

+ (NSArray *)newTestPhotosWithPoster:(Film*)film {
  NSMutableArray *photos = [NSMutableArray array];
    NYTPhotoModel *photo = [[NYTPhotoModel alloc] init];
    UIImage *image = [UIImage imageWithData: film.poster];
    photo.image = image;
  
    NSString *caption = film.title;
    NSString* credit = film.director;
    photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:caption attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
    photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:credit attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
    
    [photos addObject:photo];
  
  return photos;
}

- (IBAction)favorite:(id)sender {
  //If save film is clicked
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"Favorite Film"
                                message:@"Want to add this film to your favorites?"
                                preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                      NSUInteger i=  [[FilmManager sharedInstance] Favorite:film];
                                                 // Check if the film is already saved
                                                 if(i==1){
                                                  [self back:1];
                                                 }
                                                 [self back:0];
                                               }];
  UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                 }];
  [alert addAction:cancel];
  [alert addAction:save];
  [self presentViewController:alert animated:YES completion:nil];
}
-(void) alert{
  //Show
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"This film is Favorite!"
                                message:@"This film is already in favorites"
                                preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                               [self back:0];
                                             }];
  [alert addAction:Ok];
  [self presentViewController:alert animated:YES completion:nil];
}
-(void) back:(int)id{
  if(id==1){
    //If film is already saved show message
    [self alert];
  }else{
    //If film is not already saved
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
