#import "EditorViewController.h"

@implementation EditorViewController {
    BOOL addingMultiple;
    BOOL addingSingle;
    BOOL sizeSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideAll];
    self.singleTextField.delegate = self;
    
    [self styleBackgrounds];
    [self styleButtons];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)hideAll {
    self.view.hidden = YES;
    self.multipleTextView.hidden = YES;
    self.multipleBackgroundImageView.hidden = YES;
    self.singleTextField.hidden = YES;
    self.singleBackgroundImageView.hidden = YES;
}

- (void)beginAddingMultipleItems {
    [self setMultipleAlpha:0];
    [self setMultipleHidden:NO];
    addingMultiple = YES;
    [self.multipleTextView becomeFirstResponder];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setMultipleAlpha:1];
                     }];
}

- (void)endAddingMultipleItems {
    self.multipleTextView.text = @"";
    [self setMultipleHidden:YES];
    addingMultiple = NO;
    [self.multipleTextView resignFirstResponder];
}

- (void)setMultipleAlpha:(int)alpha {
    self.view.alpha = alpha;
    self.multipleTextView.alpha = alpha;
    self.multipleBackgroundImageView.alpha = alpha;
}

- (void)setMultipleHidden:(BOOL)hidden {
    self.view.hidden = hidden;
    self.multipleTextView.hidden = hidden;
    self.multipleBackgroundImageView.hidden = hidden;
}

- (void)commitMultiple {
    NSArray *nameArray = [self.multipleTextView.text componentsSeparatedByString:@"\n"];
    [self.delegate didFinishAddingMultipleItems:nameArray];
}

- (void)beginAddingSingleItem {
    addingSingle = YES;
    [self beginEditingSingleItem:@""];
}

- (void)beginEditingSingleItem:(NSString *)itemName {
    self.singleTextField.text = itemName;
    [self setSingleAlpha:0];
    [self setSingleHidden:NO];
    [self.singleTextField becomeFirstResponder];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setSingleAlpha:1];
                     }];
}

- (void)endEditingSingleItem {
    self.singleTextField.text = @"";
    [self setSingleHidden:YES];
    addingSingle = NO;
    [self.singleTextField resignFirstResponder];
}

- (void)setSingleAlpha:(int)alpha {
    self.view.alpha = alpha;
    self.singleTextField.alpha = alpha;
    self.singleBackgroundImageView.alpha = alpha;
}

- (void)setSingleHidden:(BOOL)hidden {
    self.view.hidden = hidden;
    self.singleTextField.hidden = hidden;
    self.singleBackgroundImageView.hidden = hidden;
}

- (void)commitSingle {
    if (addingSingle) {
        [self.delegate didFinishAddingItem:self.singleTextField.text];
    } else {
        [self.delegate didFinishEditingItem:self.singleTextField.text];
    }
}

#pragma mark - user actions

- (IBAction)didTapDone:(id)sender {
    if (addingMultiple) {
        [self commitMultiple];
        [self endAddingMultipleItems];
    } else {
        [self commitSingle];
        [self endEditingSingleItem];
    }
}

- (IBAction)didTapCancel:(id)sender {
    if (addingMultiple) {
        [self endAddingMultipleItems];
    } else {
        [self endEditingSingleItem];
    }
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didTapDone:nil];
    return YES;
}

#pragma mark - private methods

- (void)styleBackgrounds {
    UIImage *background = [[UIImage imageNamed:@"textfield"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.multipleBackgroundImageView.image = background;
    self.singleBackgroundImageView.image = background;
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
    if (!sizeSet) {
        NSDictionary* info = [notification userInfo];
        CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

        NSString *constraintString = [NSString stringWithFormat:@"V:[view]-%f-|", kbHeight];
        UIView *view = self.wrapView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                       options:NSLayoutFormatAlignAllBaseline
                                                                       metrics:nil
                                                                         views:views];
        
        [self.view removeConstraint:self.wrapViewBottomConstraint];
        [self.view addConstraints:constraints];

        sizeSet = YES;
    }
}

@end
