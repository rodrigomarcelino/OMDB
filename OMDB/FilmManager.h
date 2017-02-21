//
//  FilmManager.h
//  OMDB
//
//  Created by Zup Mac Pro on 2/14/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import "RLMFilm.h"
#import "Film.h"
#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "AFNetworking.h"

@interface FilmManager : NSObject

@property (strong) NSMutableArray *films;
@property (strong) NSMutableDictionary *movieImages;

+ (id)sharedInstance;
- (int)Favorite:(Film *)film;
- (NSURLSessionDataTask *)getFilmWithName:(NSString *)title success:(void (^)(NSMutableArray* films, int totalpages))success failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)getFilmWithPage:(NSString *)title :(int)actualpage success:(void (^)(NSMutableArray* f))success failure:(void (^)(NSError *error))failure;
- (UIImage*)imageForKey:(NSString*)imdbID;
- (NSURLSessionDataTask *)getFilmWithID:(NSString *)imdbID success:(void (^)(Film* f))success failure:(void (^)(NSError *error))failure;

@end
