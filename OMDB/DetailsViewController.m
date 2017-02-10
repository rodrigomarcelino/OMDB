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

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize imdbID;
@synthesize film;

- (void)viewDidLoad {
    [super viewDidLoad];
  
  NSLog(@"\n\nID: %@\n\n", imdbID);
  NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?i=%@&plot=short&r=json",imdbID];
  NSURL *URL = [NSURL URLWithString:link];
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  
  NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      [_hud hideAnimated:NO];
      [_hud showAnimated:NO];
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
      film = [[Film alloc]initWithDictionary:responseObject];
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
        NSString *str = @"https://az853139.vo.msecnd.net/static/images/not-found.png";
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
  }];
  //Show loading
  _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  _hud.label.text = @"Loading";
  [_hud hideAnimated:YES];
  [_hud showAnimated:YES];
  //Call function afnetwork dataTask
  [dataTask resume];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 }
- (IBAction)favorite:(id)sender {
  //If save film is clicked
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:@"Favorite Film"
                                message:@"Want to add this film to your favorites?"
                                preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                
                                                 RLMRealm *realm = [RLMRealm defaultRealm];
                                                 RLMFilm *information = [[RLMFilm alloc] init];
                                                 information.title=film.title;
                                                 information.year=film.year;
                                                 information.imdbRating=film.imdbRating;
                                                 information.plot=film.plot;
                                                 information.posterURL=film.posterURL;
                                                 information.director=film.director;
                                                 information.genre=film.genre;
                                                 information.runtime=film.runtime;
                                                 information.imdbID=film.imdbID;
                                                 information.poster = film.poster;
                                                 RLMResults<RLMFilm *> *someDogs = [RLMFilm objectsWhere:@"imdbID = %@",film.imdbID];
                                                 // Check if the film is already saved
                                                 if(someDogs.firstObject == nil){
                                                   [realm beginWriteTransaction];
                                                   [realm addObject:information];
                                                   [realm commitWriteTransaction];
                                                 }else{
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
