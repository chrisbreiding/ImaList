#import <Foundation/Foundation.h>

@class ItemTableCell;

@interface ItemPanHandler : NSObject <UIGestureRecognizerDelegate>

+ (instancetype)handlerWithTableView:(UITableView *)aTableView;
- (void)didPan:(UIGestureRecognizer *)sender;

@end

extern const CGFloat PAN_BUTTON_WIDTH;
