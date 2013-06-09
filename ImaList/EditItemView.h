#import <UIKit/UIKit.h>

@protocol EditItemViewDelegate;

@interface EditItemView : UIView <UITextFieldDelegate>

@property(nonatomic, weak) id<EditItemViewDelegate> delegate;

- (void)showWithCell:(UITableViewCell *)cell offset:(CGFloat)offset isNew:(BOOL)isNew;

@end

@protocol EditItemViewDelegate <NSObject>

- (void)didFinisheditingItemForCell:(UITableViewCell *)cell;

@end