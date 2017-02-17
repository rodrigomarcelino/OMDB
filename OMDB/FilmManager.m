//
//  FilmManager.m
//  OMDB
//
//  Created by Zup Mac Pro on 2/14/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//[[FilmManager sharedInstance] Favorite:film];


#import "FilmManager.h"

@implementation FilmManager

- (id)init{
  self = [super init];
  if(!self) return nil;
  
  _films = [[NSMutableArray alloc] init];
  
  return self;
}

+ (id)sharedInstance {
  static FilmManager *_sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[self alloc] init];
  });
  
  return _sharedInstance;
}

// Adds a new film to DATA
- (int)Favorite:(Film *)film {
  RLMRealm *realm = [RLMRealm defaultRealm];
  RLMFilm *information = [[RLMFilm alloc] init];
 // information.onDatabase=true;
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
  }
  else{
    return 1;
  }
  return 0;
}

// Removes the film from the library
- (void)Delete:(Film *)film{
  
  
}

- (NSURLSessionDataTask *)getFilmWithName:(NSString *)title success:(void (^)(NSMutableArray* f))success failure:(void (^)(NSError *error))failure {
  //exchange every "space" for "+"
  NSString *str = [title stringByReplacingOccurrencesOfString:@" "
                                                   withString:@"+"];
  NSLog(@"\n\nString New:%@",str);
  NSString *_search = str;
  //Network:
  NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json",str];
  
  NSURL *URL = [NSURL URLWithString:link];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  NSMutableArray *results = [[NSMutableArray alloc] init];
  return [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
      NSLog(@"Error!");
          } else {
      //NSUInteger *page=actualPage;
      // page++;
      // NSLog(@"\n\nfilms:%@", responseObject);
      _films = [[NSMutableArray alloc]init];
      
      NSDictionary *resultDictinary = [responseObject objectForKey:@"Search"];
      int totalResults = [[responseObject objectForKey:@"totalResults"] intValue];
      //_totalPages = ceil(totalResults/10);
      //NSLog(@"\n%@",responseObject);

            RLMFilm *information = [[RLMFilm alloc] init];
      for (NSDictionary *filmDictionary in resultDictinary)
      {
        Film *newFilm=[[Film alloc]initWithDictionary:filmDictionary];
        [_films addObject:newFilm];
      }
      success(_films);
      NSLog(@"1\n%@",_films);
      
    }
  }
       failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
       }];
}

// Returns a list of films whose key contains the given string
- (NSMutableArray*)searchFilmsWithKey:(NSString*)text{
  NSString *key = [[text lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  NSMutableArray *results = [[NSMutableArray alloc] init];
  
  for(int i = 0; i < [_films count]; i++){
    RLMFilm *m = [_films objectAtIndex:i];
    // if([m.key containsString:key])
    //    [results addObject:m];
  }
  
  return results;
  
}

@end