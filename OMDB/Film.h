//
//  Film.h
//  OMDB
//
//  Created by Zup Mac Pro on 1/25/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Film : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *year;
@property(nonatomic, strong) NSString *rated;
@property(nonatomic, strong) NSString *runtime;
@property(nonatomic, strong) NSString *genre;
@property(nonatomic, strong) NSString *director;
@property(nonatomic, strong) NSString *plot;
@property(nonatomic, strong) NSString *posterURL;
@property(nonatomic, strong) NSData *poster;
@property(nonatomic, strong) NSString *imdbRating;
@property(nonatomic, strong) NSString *imdbID;
@property(nonatomic, strong) NSString *type;

-(id)initWithDictionary:(NSDictionary *)sourceDictionary;

@end
