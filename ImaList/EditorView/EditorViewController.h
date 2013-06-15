#import <UIKit/UIKit.h>

@protocol EditorDelegate;

@interface EditorViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, weak) id<EditorDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *wrapView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wrapViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *multipleBackgroundImageView;
@property (nonatomic, weak) IBOutlet UITextView *multipleTextView;
@property (nonatomic, weak) IBOutlet UIImageView *singleBackgroundImageView;
@property (nonatomic, weak) IBOutlet UITextField *singleTextField;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;

- (void)beginAddingMultipleItems;
- (void)beginEditingSingleItem:(NSString *)itemName;

@end

@protocol EditorDelegate <NSObject>

- (void)didFinishEditingItem:(NSString *)itemName;
- (void)didFinishAddingItems:(NSArray *)itemNames;

@end
