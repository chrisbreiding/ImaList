#import "EditItemViewController.h"

@implementation EditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleMultipleBackground];
    [self styleButtons];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
//    [self.multipleTextView becomeFirstResponder];
}

#pragma mark - user actions

- (IBAction)didTapDone:(id)sender {
    
}

- (IBAction)didTapCancel:(id)sender {
    
}

#pragma mark - private methods

- (void)styleMultipleBackground {
    _multipleBackgroundImageView.image = [[UIImage imageNamed:@"textfield"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)styleButtons {
    [self styleButton:self.doneButton imageName:@"done-button"];
    [self styleButton:self.cancelButton imageName:@"cancel-button"];
}

- (void)styleButton:(UIButton *)button imageName:(NSString *)imageName {
    UIImage *bgImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGSize size = self.view.bounds.size;
    self.view.bounds = CGRectMake(0, 0, size.width, size.height - kbSize.height);
}

@end
