#import "EditorViewController.h"
#import "Item.h"

@implementation EditorViewController {
    Item *itemBeingEdited;
    BOOL editingSingle;
    BOOL sizeSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideAll];
    self.textView.delegate = self;

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
    self.textView.hidden = YES;
}

- (void)beginEditing {
    [self setTextViewAlpha:0];
    [self setHidden:NO];
    [self.textView becomeFirstResponder];
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setTextViewAlpha:1];
                     }];
}

- (void)endEditing {
    self.textView.text = @"";
    [self setHidden:YES];
    [self.textView resignFirstResponder];
}

- (void)beginEditingMultiple {
    [self beginEditing];
}

- (void)endEditingMultipleItems {
    [self endEditing];
}

- (void)setTextViewAlpha:(int)alpha {
    self.view.alpha = alpha;
    self.textView.alpha = alpha;
}

- (void)setHidden:(BOOL)hidden {
    self.view.hidden = hidden;
    self.textView.hidden = hidden;
}

- (void)commitMultiple {
    NSArray *nameArray = [self.textView.text componentsSeparatedByString:@"\n"];
    [self.delegate didFinishEditingMultiple:nameArray];
}

- (void)beginEditingSingle:(NSString *)text {
    editingSingle = YES;
    self.textView.text = text;
    [self beginEditing];
}

- (void)endEditingSingleItem {
    editingSingle = NO;
    [self endEditing];
}

- (void)commitSingle {
    [self.delegate didFinishEditingSingle:self.textView.text];
}

#pragma mark - user actions

- (IBAction)didTapDone:(id)sender {
    if (editingSingle) {
        [self commitSingle];
        [self endEditingSingleItem];
    } else {
        [self commitMultiple];
        [self endEditingMultipleItems];
    }
}

- (IBAction)didTapCancel:(id)sender {
    if (editingSingle) {
        [self endEditingSingleItem];
    } else {
        [self endEditingMultipleItems];
    }
}

#pragma mark - textfield delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL isReturn = [text isEqualToString:@"\n"];
    if (editingSingle && isReturn) {
        [self didTapDone:nil];
        return NO;
    } else {
        return YES;        
    }
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
