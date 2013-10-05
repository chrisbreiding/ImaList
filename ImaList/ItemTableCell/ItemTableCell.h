#import <UIKit/UIKit.h>

@class Item;
@protocol ItemCellDelegate;

@interface ItemTableCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<ItemCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *checkboxButton;
@property (nonatomic, weak) IBOutlet UIButton *importantButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIImageView *importantMarker;
@property (nonatomic, weak) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerLeadingConstraint;
@property (nonatomic, strong) Item *item;

- (IBAction)didTapCheckmark:(id)sender;
- (void)configureCellWithItem:(Item *)item;

@end

@protocol ItemCellDelegate <NSObject>

- (void)didUpdateItem:(Item *)item isChecked:(BOOL)isChecked;
- (void)didUpdateItem:(Item *)item importance:(NSUInteger)importance;
- (void)didDeleteItem:(Item *)item;

@end