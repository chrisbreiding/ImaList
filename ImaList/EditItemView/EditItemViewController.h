#import <UIKit/UIKit.h>

@interface EditItemViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *multipleBackgroundImageView;
@property (nonatomic, weak) IBOutlet UITextView *multipleTextView;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapCancel:(id)sender;

@end
