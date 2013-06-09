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
    
    ItemTableCell *_cellBeingEdited;
    CGFloat _itemY;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        [self addTempLabel];
        [self addBackground];
        [self addNameField];
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

- (void)addBackground {
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

- (void)showWithCell:(ItemTableCell *)cell offset:(CGFloat)offset isNew:(BOOL)isNew {
    _cellBeingEdited = cell;
    if (isNew) {
        _itemY = 360;
    } else {
        _itemY = _cellBeingEdited.frame.origin.y + 50 - offset;
    }
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

- (void)hide {
    [_nameField resignFirstResponder];
    NSString *newName = _nameField.text;
    _tempLabel.text = newName;
    _cellBeingEdited.itemNameLabel.text = newName;
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
            }];
        }];
    }];
    
    [self.delegate didFinisheditingItemForCell:_cellBeingEdited];
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

@end
