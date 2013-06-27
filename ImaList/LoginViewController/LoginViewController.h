#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *emailBackground;
@property (nonatomic, weak) IBOutlet UIImageView *passwordBackground;
@property (nonatomic, weak) IBOutlet UILabel *invalidLoginLabel;

- (IBAction)attemptLogin:(id)sender;

@end
