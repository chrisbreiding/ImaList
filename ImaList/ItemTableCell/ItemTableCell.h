#import <UIKit/UIKit.h>

@class Item;

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteButtonTrailingConstraint;

- (IBAction)didTapDelete:(id)sender;
- (void)configureCellWithItem:(Item *)item index:(int)index;

@end
