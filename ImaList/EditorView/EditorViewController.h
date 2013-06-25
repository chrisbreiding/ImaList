#import <UIKit/UIKit.h>

@class Item;
@protocol EditorDelegate;

@interface EditorViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, weak) id<EditorDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIView *wrapView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wrapViewBottomConstraint;
@property (nonatomic, weak) IBOutlet UITextView *multipleTextView;
@property (nonatomic, weak) IBOutlet UITextField *singleTextField;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;

- (void)beginAddingMultipleItems;
- (void)beginEditingSingleItem:(Item *)item;

@end

@protocol EditorDelegate <NSObject>

- (void)didFinishEditingItem:(Item *)item name:(NSString *)name;
- (void)didFinishAddingItems:(NSArray *)itemNames;

@end
