#import <UIKit/UIKit.h>

@protocol CRBEditItemViewDelegate;

@interface CRBEditItemView : UIView <UITextFieldDelegate>

@property(nonatomic, weak) id<CRBEditItemViewDelegate> delegate;

- (void)showWithCell:(UITableViewCell *)cell offset:(CGFloat)offset isNew:(BOOL)isNew;

@end

@protocol CRBEditItemViewDelegate <NSObject>

- (void)didFinisheditingItemForCell:(UITableViewCell *)cell;

@end