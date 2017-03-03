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
@property (strong) NSMutableDictionary *filmsImages;

+ (id)sharedInstance;
- (int)favoriteSave:(Film *)film;
- (NSURLSessionDataTask *)getFilmWithName:(NSString *)title success:(void (^)(NSMutableArray* films, int totalPages))success failure:(void (^)(NSError *error))failure;
- (NSURLSessionDataTask *)getFilmWithPage:(NSString *)title :(int)actualPage success:(void (^)(NSMutableArray* films))success failure:(void (^)(NSError *error))failure;
- (UIImage*)imageForKey:(NSString*)imdbID;
- (NSURLSessionDataTask *)getFilmWithID:(NSString *)imdbID success:(void (^)(Film* films))success failure:(void (^)(NSError *error))failure;

@end
