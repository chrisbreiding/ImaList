#import "EditItemView.h"
#import "ItemTableCell.h"

static CGFloat itemX = 75;
static CGFloat itemWidth = 250;
static CGFloat itemHeight = 60;

static CGFloat nameFieldX = 30;
static CGFloat nameFieldY = 50;
static CGFloat nameFieldWidth = 260;

@implementation EditItemView {
    UIView *_shadowboxView;
    UILabel *_tempLabel;
    UITextField *_nameField;
    UIImageView *_nameFieldBackground;
    UITextView *_nameView;
    UIImageView *_nameViewBackground;
    UIButton *_doneButton;
    
    ItemTableCell *_cellBeingEdited;
    Item *_itemBeingEdited;
    BOOL _editingMultiple;
    CGFloat _itemY;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        [self addTempLabel];
        [self addNameFieldBackground];
        [self addNameField];
        [self addNameViewBackground];
        [self addNameView];
        [self addMultipleDoneButton];
        [self addActions];
    }
    return self;
}

- (void)addTempLabel {
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont systemFontOfSize:16];
    _tempLabel = tempLabel;
    [self addSubview:tempLabel];
}

- (void)addNameFieldBackground {
    UIImageView *nameFieldBackground = [[UIImageView alloc] initWithFrame:CGRectMake(nameFieldX - 15, nameFieldY, nameFieldWidth + 30, itemHeight)];
    nameFieldBackground.image = [[UIImage imageNamed:@"textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    nameFieldBackground.alpha = 0;
    _nameFieldBackground = nameFieldBackground;
    [self addSubview:nameFieldBackground];
}

- (void)addNameField {
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(nameFieldX, nameFieldY, nameFieldWidth, itemHeight)];
    nameField.font = [UIFont systemFontOfSize:16];
    nameField.textColor = [UIColor whiteColor];
    nameField.alpha = 0;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.delegate = self;
    _nameField = nameField;
    [self addSubview:nameField];
}

- (void)addNameViewBackground {
    UIImageView *nameViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(nameFieldX - 15, nameFieldY - 15, nameFieldWidth + 30, itemHeight * 2 + 30)];
    nameViewBackground.image = [[UIImage imageNamed:@"textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    nameViewBackground.alpha = 0;
    _nameViewBackground = nameViewBackground;
    [self addSubview:nameViewBackground];
}

- (void)addNameView {
    UITextView *nameView = [[UITextView alloc] initWithFrame:CGRectMake(nameFieldX - 5, nameFieldY, nameFieldWidth + 10, itemHeight * 2)];
    nameView.backgroundColor = [UIColor clearColor];
    nameView.font = [UIFont systemFontOfSize:16];
    nameView.textColor = [UIColor whiteColor];
    nameView.alpha = 0;
    _nameView = nameView;
    [self addSubview:nameView];    
}

- (void)addMultipleDoneButton {
    CGFloat width = 70;
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - width - 15,
                                                                      nameFieldY + itemHeight * 2 + 25,
                                                                      width,
                                                                      40)];
    [doneButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)] forState:UIControlStateNormal];
    doneButton.titleLabel.textColor = [UIColor whiteColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.alpha = 0;
    _doneButton = doneButton;
    
    [doneButton addTarget:self
                   action:@selector(didTapDone:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:doneButton];
}

#pragma mark - showing/hiding

- (void)showWithCell:(ItemTableCell *)cell offset:(CGFloat)offset {
    _cellBeingEdited = cell;
    _itemY = _cellBeingEdited.frame.origin.y + 50 - offset;
    _tempLabel.text = cell.itemNameLabel.text;
    _nameField.text = cell.itemNameLabel.text;
    _tempLabel.frame = CGRectMake(itemX, _itemY, itemWidth, itemHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.8;
        _tempLabel.alpha = 1;
    } completion:^(BOOL finished) {
        cell.itemNameLabel.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            _tempLabel.frame = CGRectMake(nameFieldX, nameFieldY, nameFieldWidth, itemHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _nameFieldBackground.alpha = 1;
                _nameField.alpha = 1;
                _tempLabel.alpha = 0;
            }];
            [_nameField becomeFirstResponder];
        }];
    }];
}

- (void)showForNewItem {
    _nameField.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.8;
        _nameFieldBackground.alpha = 1;
        _nameField.alpha = 1;
    } completion:^(BOOL finished) {
        [_nameField becomeFirstResponder];
    }];
}

- (void)showForMultipleNewItems {
    _editingMultiple = YES;
    _nameView.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.8;
        _nameViewBackground.alpha = 1;
        _nameView.alpha = 1;
        _doneButton.alpha = 1;
    } completion:^(BOOL finished) {
        [_nameView becomeFirstResponder];
    }];
}

- (void)hide {
    if (_cellBeingEdited) {
        [self hideWithCell];
    } else {
        if (_editingMultiple) {
            [self hideWithMultipleItems];
            _editingMultiple = NO;
        } else {
            [self hideWithItem];
        }
    }
}

- (void)hideWithCell {
    [_nameField resignFirstResponder];
    NSString *newName = _nameField.text;
    _tempLabel.text = newName;
    _cellBeingEdited.itemNameLabel.text = newName;
    [self.delegate didFinishEditingItemForCell:_cellBeingEdited];

    [UIView animateWithDuration:0.2 animations:^{
        _nameFieldBackground.alpha = 0;
        _nameField.alpha = 0;
        _tempLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _tempLabel.frame = CGRectMake(itemX, _itemY, itemWidth, itemHeight);
        } completion:^(BOOL finished) {
            _tempLabel.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
                _cellBeingEdited.itemNameLabel.hidden = NO;
            } completion:^(BOOL finished) {
                _cellBeingEdited = nil;
            }];
        }];
    }];    
}

- (void)hideWithItem {
    [_nameField resignFirstResponder];
    [self.delegate didFinishAddingItem:_nameField.text];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _nameFieldBackground.alpha = 0;
        _nameField.alpha = 0;
    }];
}

- (void)hideWithMultipleItems {
    [_nameView resignFirstResponder];
    NSArray *nameArray = [_nameView.text componentsSeparatedByString:@"\n"];
    [self.delegate didFinishAddingMultipleItems:nameArray];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _nameViewBackground.alpha = 0;
        _nameView.alpha = 0;
        _doneButton.alpha = 0;
    }];
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hide];
    return YES;
}

#pragma mark - user actions

- (void)addActions {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(didSwipeDownOnEditor:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self setGestureRecognizers:@[swipeRecognizer]];
}

- (void)didSwipeDownOnEditor:(id)gesture {
    [self hide];
}

- (void)didTapDone:(id)sender {
    [self hide];
}

@end
