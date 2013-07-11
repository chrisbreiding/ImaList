#import "EditorViewController.h"
#import "Item.h"

@implementation EditorViewController {
    Item *itemBeingEdited;
    BOOL addingMultiple;
    BOOL sizeSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideAll];
    self.singleTextField.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)hideAll {
    self.view.hidden = YES;
    self.multipleTextView.hidden = YES;
    self.singleTextField.hidden = YES;
}

- (void)beginEditingMultiple {
    [self setMultipleAlpha:0];
    [self setMultipleHidden:NO];
    addingMultiple = YES;
    [self.multipleTextView becomeFirstResponder];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setMultipleAlpha:1];
                     }];
}

- (void)endEditingMultipleItems {
    self.multipleTextView.text = @"";
    [self setMultipleHidden:YES];
    addingMultiple = NO;
    [self.multipleTextView resignFirstResponder];
}

- (void)setMultipleAlpha:(int)alpha {
    self.view.alpha = alpha;
    self.multipleTextView.alpha = alpha;
}

- (void)setMultipleHidden:(BOOL)hidden {
    self.view.hidden = hidden;
    self.multipleTextView.hidden = hidden;
}

- (void)commitMultiple {
    NSArray *nameArray = [self.multipleTextView.text componentsSeparatedByString:@"\n"];
    [self.delegate didFinishEditingMultiple:nameArray];
}

- (void)beginEditingSingle:(NSString *)text {
    self.singleTextField.text = text;
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
    [self.singleTextField resignFirstResponder];
}

- (void)setSingleAlpha:(int)alpha {
    self.view.alpha = alpha;
    self.singleTextField.alpha = alpha;
}

- (void)setSingleHidden:(BOOL)hidden {
    self.view.hidden = hidden;
    self.singleTextField.hidden = hidden;
}

- (void)commitSingle {
    [self.delegate didFinishEditingSingle:self.singleTextField.text];
}

#pragma mark - user actions

- (IBAction)didTapDone:(id)sender {
    if (addingMultiple) {
        [self commitMultiple];
        [self endEditingMultipleItems];
    } else {
        [self commitSingle];
        [self endEditingSingleItem];
    }
}

- (IBAction)didTapCancel:(id)sender {
    if (addingMultiple) {
        [self endEditingMultipleItems];
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
