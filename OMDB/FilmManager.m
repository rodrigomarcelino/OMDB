//
//  FilmManager.m
//  OMDB
//
//  Created by Zup Mac Pro on 2/14/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//


#import "FilmManager.h"

@implementation FilmManager

- (id)init{
  self = [super init];
  if(!self) return nil;
  
  _films = [[NSMutableArray alloc] init];
  _filmsImages = [[NSMutableDictionary alloc] init];
  
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

- (int)favoriteSave:(Film *)film {
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
  RLMResults<RLMFilm *> *check = [RLMFilm objectsWhere:@"imdbID = %@",film.imdbID];
  // Check if the film is already saved
  if(check.firstObject == nil){
    [realm beginWriteTransaction];
    [realm addObject:information];
    [realm commitWriteTransaction];
  }
  else{
    return 1;
  }
  return 0;
}

- (NSURLSessionDataTask *)getFilmWithName:(NSString *)title success:(void (^)(NSMutableArray* films, int totalPages))success failure:(void (^)(NSError *error))failure {
  //exchange every "space" for "+"
  NSString *str = [title stringByReplacingOccurrencesOfString:@" "
                                                   withString:@"+"];
  NSLog(@"\n\nString New:%@",str);
  //Network:
  NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json",str];
  
  NSURL *URL = [NSURL URLWithString:link];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  return [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
      NSLog(@"Error!");
      success(NULL, 0);
          } else {
      _films = [[NSMutableArray alloc]init];
      
      NSDictionary *resultDictinary = [responseObject objectForKey:@"Search"];
      int totalResults = [[responseObject objectForKey:@"totalResults"] intValue];
      int totalPages = ceil(totalResults/10)+1;
      NSLog(@"\n%@",responseObject);
      for (NSDictionary *filmDictionary in resultDictinary)
      {
        Film *newFilm=[[Film alloc]initWithDictionary:filmDictionary];
        if([newFilm.posterURL  isEqualToString:@"N/A"])  {
          // If the film has no picture add not-found image
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://filmesonlinegratis.club/uploads/posts/2016-06/1466777116_1459367668_no_poster.png"]]];
          [_filmsImages setObject:image forKey:newFilm.imdbID];
        }else{
          //exchang every "http:" for "https:"
          NSString *str = [newFilm.posterURL stringByReplacingOccurrencesOfString:@"http:"
                                                                       withString:@"https:"];
          UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
          [_filmsImages setObject:image forKey:newFilm.imdbID];
        }
        [_films addObject:newFilm];
      }
      success(_films, totalPages);
      
    }
  }
       failure:^(NSURLSessionTask *operation, NSError *error) {
         failure(NULL);
       }];
}

- (NSURLSessionDataTask *)getFilmWithPage:(NSString *)title :(int)currentPage success:(void (^)(NSMutableArray* films))success failure:(void (^)(NSError *error))failure {
  NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&page=%d",title,currentPage];
  
  NSURL *URL = [NSURL URLWithString:link];
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  return [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
      NSLog(@"Error!");
    } else {
      _films = [[NSMutableArray alloc]init];
      
      NSDictionary *resultDictinary = [responseObject objectForKey:@"Search"];
      NSLog(@"\n%@",responseObject);
      for (NSDictionary *filmDictionary in resultDictinary)
      {
        
        Film *newFilm=[[Film alloc]initWithDictionary:filmDictionary];
        if([newFilm.posterURL  isEqualToString:@"N/A"])  {
          // If the film has no picture add not-found image
          UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://filmesonlinegratis.club/uploads/posts/2016-06/1466777116_1459367668_no_poster.png"]]];
          [_filmsImages setObject:image forKey:newFilm.imdbID];
        }else{
          //exchang every "http:" for "https:"
          NSString *str = [newFilm.posterURL stringByReplacingOccurrencesOfString:@"http:"
                                                                    withString:@"https:"];
          
          UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
          [_filmsImages setObject:image forKey:newFilm.imdbID];
        }
        [_films addObject:newFilm];
      }
      success(_films);
      
    }
  }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
              }];
}

// Returns an image for the given key
- (UIImage*)imageForKey:(NSString*)imdbID{
  return [_filmsImages objectForKey:imdbID];
}

- (NSURLSessionDataTask *)getFilmWithID:(NSString *)imdbID success:(void (^)(Film* films))success failure:(void (^)(NSError *error))failure{
      NSString *link = [NSString stringWithFormat:@"https://www.omdbapi.com/?i=%@&plot=short&r=json",imdbID];
      NSURL *URL = [NSURL URLWithString:link];
      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      return [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
          if ([[responseObject objectForKey:@"Response"] isEqualToString:@"False"]) {
            success(NULL);
                                               }
       else {
   Film* film = [[Film alloc]initWithDictionary:responseObject];
    success (film);
    }
      }
     failure:^(NSURLSessionTask *operation, NSError *error) {
       NSLog(@"Error: %@", error);
     }];
}

@end
