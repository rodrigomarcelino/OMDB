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

+ (id)sharedInstance;
- (int)Favorite:(Film *)film;
- (NSURLSessionDataTask *)getFilmWithName:(NSString *)title success:(void (^)(NSMutableArray* films))success failure:(void (^)(NSError *error))failure;


@end
