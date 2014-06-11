#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.emailTextField becomeFirstResponder];
}

- (IBAction)attemptLogin:(id)sender {
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com"];
    FirebaseSimpleLogin *authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    @try {
        [authClient loginWithEmail:self.emailTextField.text
                       andPassword:self.passwordTextField.text
               withCompletionBlock:^(NSError* error, FAUser* user) {
                   if (error != nil) {
                       NSLog(@"error logging in: %@", error);
                       self.invalidLoginLabel.hidden = NO;
                   } else {
                       self.invalidLoginLabel.hidden = YES;
                   }
               }];
    } @catch (NSException *exception) {
        NSLog(@"exception thrown while logging in: %@", exception);
        self.invalidLoginLabel.hidden = NO;
    }
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self attemptLogin:nil];
    }
    return YES;
}

@end
