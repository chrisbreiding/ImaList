#import <UIKit/UIKit.h>

@class Item;
@protocol ItemCellDelegate;

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) id<ItemCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteButtonTrailingConstraint;
@property (nonatomic, strong) Item *item;

- (IBAction)didTapDelete:(id)sender;
- (void)configureCellWithItem:(Item *)item;

@end

@protocol ItemCellDelegate <NSObject>

- (void)didUpdateItem:(Item *)item isChecked:(BOOL)isChecked;
- (void)didDeleteItem:(Item *)item;

@end