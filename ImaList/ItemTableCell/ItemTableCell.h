#import <UIKit/UIKit.h>

@class Item;
@protocol ItemCellDelegate;

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) id<ItemCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *checkboxButton;
@property (nonatomic, weak) IBOutlet UIButton *importantButton;
@property (nonatomic, weak) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteButtonTrailingConstraint;
@property (nonatomic, strong) Item *item;

- (IBAction)didTapCheckmark:(id)sender;
- (IBAction)didTapImportant:(id)sender;
- (IBAction)didTapDelete:(id)sender;
- (void)configureCellWithItem:(Item *)item;

@end

@protocol ItemCellDelegate <NSObject>

- (void)didUpdateItem:(Item *)item isChecked:(BOOL)isChecked;
- (void)didUpdateItem:(Item *)item importance:(NSUInteger)importance;
- (void)didDeleteItem:(Item *)item;

@end