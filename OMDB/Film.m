//
//  Film.m
//  OMDB
//
//  Created by Zup Mac Pro on 1/25/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import "Film.h"

@implementation Film: NSObject
@synthesize title, year, rated, runtime, genre, director, plot, posterURL, imdbRating, imdbID, type;


-(id)initWithDictionary:(NSDictionary *)sourceDictionary
{
  self = [super init];
  if (self != nil)
  {
    self.title = [sourceDictionary objectForKey:@"Title"];
    self.year = [sourceDictionary objectForKey:@"Year"];
    self.rated = [sourceDictionary objectForKey:@"Rated"];
    self.runtime = [sourceDictionary objectForKey:@"Runtime"];
    self.genre = [sourceDictionary objectForKey:@"Genre"];
    self.director = [sourceDictionary objectForKey:@"Director"];
    self.plot = [sourceDictionary objectForKey:@"Plot"];
    self.posterURL = [sourceDictionary objectForKey:@"Poster"];
    self.imdbRating = [sourceDictionary objectForKey:@"imdbRating"];
    self.imdbID = [sourceDictionary objectForKey:@"imdbID"];
    self.type = [sourceDictionary objectForKey:@"Type"];
  }
  return self;
}

@end
