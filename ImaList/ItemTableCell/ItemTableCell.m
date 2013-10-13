#import "ItemTableCell.h"
#import "Item.h"

static const CGFloat PAN_BUTTON_WIDTH = 130;

@implementation ItemTableCell {
    CGPoint originalPanPoint;
    CGFloat panXOffset;
    BOOL panIntended;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)configureCellWithItem:(Item *)item {
    _item = item;
    [self addAttributes];
    [self addGestures];
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
    pan.delegate = self;
    pan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didPan:(UIGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            originalPanPoint = [sender locationInView:self];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            NSInteger offsetX = fabsf(touchPoint.x - originalPanPoint.x);
            NSInteger offsetY = fabsf(touchPoint.y - originalPanPoint.y);
            if ( offsetX < 20 || offsetY > 20 ) {
                panIntended = NO;
                if (offsetY > 20) {
                    [self resetViewCompletion:nil];
                }
                return;
            }
            if ( !panIntended ) {
                panXOffset = touchPoint.x;
                panIntended = YES;
            }
            CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchPoint.x - panXOffset);
            if (newX < 0 && newX > -(PAN_BUTTON_WIDTH * 2)) {
                self.containerLeadingConstraint.constant = newX;
            }
            if (newX > 0 || newX < -(PAN_BUTTON_WIDTH * 2)) {
                self.importantButton.titleLabel.text = self.deleteButton.titleLabel.text = @"release!";
            } else {
                self.importantButton.titleLabel.text = self.deleteButton.titleLabel.text = @"";
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            if (panIntended) {
                CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchPoint.x - panXOffset);
                if (newX > 0) {
                    [self changeImportance];
                } else if (newX < -(PAN_BUTTON_WIDTH * 2)) {
                    [self delete];
                } else {
                    [self resetViewCompletion:nil];
                }
            } else {
                [self resetViewCompletion:nil];
            }
            panIntended = NO;
        }
            
        default:
            break;
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
