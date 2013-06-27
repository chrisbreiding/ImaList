#import <FirebaseAuthClient/FirebaseAuthClient.h>
#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self style];
    [self.emailTextField becomeFirstResponder];
}

- (void)style {
    UIImage *textFieldBg = [[UIImage imageNamed:@"textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    self.emailBackground.image = textFieldBg;
    self.passwordBackground.image = textFieldBg;
}

- (IBAction)attemptLogin:(id)sender {
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com"];
    FirebaseAuthClient* authClient = [[FirebaseAuthClient alloc] initWithRef:ref];
    [authClient loginWithEmail:self.emailTextField.text
                   andPassword:self.passwordTextField.text
           withCompletionBlock:^(NSError* error, FAUser* user) {
               if (error != nil) {
                   NSLog(@"error logging in");
               } else {
                   [self dismissViewControllerAnimated:YES completion:nil];
               }
           }];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field return");
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self attemptLogin:nil];
    }
    return YES;
}

@end
