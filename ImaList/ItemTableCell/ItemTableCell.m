#import "ItemTableCell.h"
#import "Item.h"

static const CGFloat PAN_BUTTON_WIDTH = 130;

@implementation ItemTableCell {
    CGFloat panOffset;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self addGestures];
}

-(void)configureCellWithItem:(Item *)item {
    _item = item;
    [self addAttributes];
}

- (void)addAttributes {
    self.itemNameLabel.text = _item.name;
    self.containerLeadingConstraint.constant = -PAN_BUTTON_WIDTH;
    
    NSString *checkImageName = @"icon-unchecked.png";
    UIColor *labelColor = [UIColor blackColor];
    if (_item.isChecked) {
        checkImageName = @"icon-checked.png";
        labelColor = [UIColor lightGrayColor];
        self.importantMarker.hidden = YES;
    } else if (_item.importance > 0) {
        self.importantMarker.hidden = NO;
    } else {
        self.importantMarker.hidden = YES;
    }
    [self.checkboxButton setImage:[UIImage imageNamed:checkImageName] forState:UIControlStateNormal];
    self.itemNameLabel.textColor = labelColor;
}

- (IBAction)didTapCheckmark:(id)sender {
    [self.delegate didUpdateItem:_item isChecked:!_item.isChecked];
}

#pragma mark - gestures

- (void)addGestures {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didPan:)];
    [self addGestureRecognizer:pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didPan:(UIGestureRecognizer *)sender {
    CGFloat touchX = [sender locationInView:self].x;
    if (sender.state == UIGestureRecognizerStateBegan) {
        panOffset = touchX;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchX - panOffset);
        if (newX < 0 && newX > -(PAN_BUTTON_WIDTH * 2)) {
            self.containerLeadingConstraint.constant = newX;
        }
        if (newX > 0 || newX < -(PAN_BUTTON_WIDTH * 2)) {
            self.importantButton.titleLabel.text = self.deleteButton.titleLabel.text = @"release!";
        } else {
            self.importantButton.titleLabel.text = self.deleteButton.titleLabel.text = @"";
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchX - panOffset);
        if (newX > 0) {
            [self changeImportance];
        } else if (newX < -(PAN_BUTTON_WIDTH * 2)) {
            [self delete];
        } else {
            [self resetViewCompletion:nil];
        }
    }
}

- (void)resetViewCompletion:(void (^)())completion {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.containerLeadingConstraint.constant = -PAN_BUTTON_WIDTH;
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

#pragma mark - actions

- (void)changeImportance {
    NSUInteger importance = _item.importance;
    importance++;
    if (importance > MAX_ITEM_IMPORTANCE) {
        importance = 0;
    }
    [self resetViewCompletion:^{
        [self.delegate didUpdateItem:_item importance:importance];
    }];
}

- (void)delete {
    [self.delegate didDeleteItem:_item];
}

@end
