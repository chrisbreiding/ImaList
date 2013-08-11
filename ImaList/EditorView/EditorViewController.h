#import <UIKit/UIKit.h>

@class Item;
@protocol EditorDelegate;

@interface EditorViewController : UIViewController <UITextViewDelegate>

@property(nonatomic, weak) id<EditorDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *wrapView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wrapViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;

- (void)beginEditingSingle:(NSString *)text;
- (void)beginEditingMultiple;

@end

@protocol EditorDelegate <NSObject>

@optional
- (void)didFinishEditingSingle:(NSString *)text;
- (void)didFinishEditingMultiple:(NSArray *)textArray;

@end
