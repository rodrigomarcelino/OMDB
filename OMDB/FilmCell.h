//
//  FilmCell.h
//  OMDB
//
//  Created by Zup Mac Pro on 1/25/17.
//  Copyright © 2017 Zup Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
