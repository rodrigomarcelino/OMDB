//
//  RLMFilm.h
//  OMDB
//
//  Created by Zup Mac Pro on 2/1/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMFilm : RLMObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *year;
@property(nonatomic, copy) NSString *rated;
@property(nonatomic, copy) NSString *runtime;
@property(nonatomic, copy) NSString *genre;
@property(nonatomic, copy) NSString *director;
@property(nonatomic, copy) NSString *plot;
@property(nonatomic, copy) NSString *posterURL;
@property(nonatomic, copy) NSData *poster;
@property(nonatomic, copy) NSString *imdbRating;
@property(nonatomic, copy) NSString *imdbID;
@property(nonatomic, copy) NSString *type;
@end
