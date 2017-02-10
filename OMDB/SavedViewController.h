//
//  SavedViewController.h
//  
//
//  Created by Zup Mac Pro on 1/30/17.
//
//

#import <UIKit/UIKit.h>
#import "RLMFilm.h"

@interface SavedViewController : UITableViewController{
  RLMResults *tableDataArray;//Favorites storage array
  RLMFilm *selectedDataObject;//Selected object
}
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)deleteFilm;//Auxiliary function for delete selected film
@end
