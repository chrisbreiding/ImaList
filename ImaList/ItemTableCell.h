#import <UIKit/UIKit.h>

@class Item;

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemNameLabel;

-(void)configureCellWithItem:(Item *)item index:(int)index;

@end