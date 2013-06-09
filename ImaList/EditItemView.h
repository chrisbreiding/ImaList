#import <UIKit/UIKit.h>

@protocol EditItemViewDelegate;

@interface EditItemView : UIView <UITextFieldDelegate>

@property(nonatomic, weak) id<EditItemViewDelegate> delegate;

- (void)showWithCell:(UITableViewCell *)cell offset:(CGFloat)offset;
- (void)showForNewItem;

@end

@protocol EditItemViewDelegate <NSObject>

- (void)didFinishEditingItemForCell:(UITableViewCell *)cell;
- (void)didFinishAddingItem:(NSString *)itemName;

@end