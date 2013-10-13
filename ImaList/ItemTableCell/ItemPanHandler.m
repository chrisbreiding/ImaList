#import "ItemPanHandler.h"
#import "ItemTableCell.h"

const CGFloat PAN_BUTTON_WIDTH = 130;

@implementation ItemPanHandler {
    ItemTableCell *cell;
    CGPoint originalPanPoint;
    CGPoint originalPointInParent;
    CGFloat panOffsetX;
    BOOL panIntended;
    BOOL panCancelled;
}

+ (instancetype)handlerWithCell:(ItemTableCell *)cell {
    return [[ItemPanHandler alloc] initWithCell:cell];
}

- (instancetype)initWithCell:(ItemTableCell *)aCell {
    self = [super init];
    if (self) {
        cell = aCell;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didPan:(UIGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self beginPan:sender];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self changePan:sender];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self endPan:sender];
            break;
            
        default:
            break;
    }
}

- (void)beginPan:(UIGestureRecognizer *)sender {
    originalPanPoint = [sender locationInView:cell];
    originalPointInParent = [sender locationInView:cell.superview];
}

- (void)changePan:(UIGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:cell];
    CGFloat offsetX = fabsf(touchPoint.x - originalPanPoint.x);
    CGPoint pointInParent = [sender locationInView:cell.superview];
    CGFloat scrollOffsetY = fabsf(pointInParent.y - originalPointInParent.y);
    if ([self shouldNotPanAtX:offsetX scrollY:scrollOffsetY]) {
        panIntended = NO;
        if (scrollOffsetY > 20) {
            [cell resetViewCompletion:nil];
            panCancelled = YES;
        }
        return;
    }
    if (!panIntended) {
        panOffsetX = touchPoint.x;
        panIntended = YES;
    }
    CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchPoint.x - panOffsetX);
    if ([self shouldUpdateCellPositionAtX:newX]) {
        cell.containerLeadingConstraint.constant = newX;
    }
    if ([self canReleaseToTakeActionAtX:newX]) {
        cell.importantButton.titleLabel.text = cell.deleteButton.titleLabel.text = @"release!";
    } else {
        cell.importantButton.titleLabel.text = cell.deleteButton.titleLabel.text = @"";
    }
}

- (void)endPan:(UIGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:cell];
    if (panIntended) {
        CGFloat newX = (-PAN_BUTTON_WIDTH) + (touchPoint.x - panOffsetX);
        if ([self shouldChangeImportanceAtX:newX]) {
            [cell changeImportance];
        } else if ([self shouldDeleteAtX:newX]) {
            [cell delete];
        } else {
            [cell resetViewCompletion:nil];
        }
    } else {
        [cell resetViewCompletion:nil];
    }
    panIntended = NO;
    panCancelled = NO;
}

- (BOOL)shouldNotPanAtX:(CGFloat)x scrollY:(CGFloat)y {
    return x < 20 || y > 20 || panCancelled;
}

- (BOOL)shouldUpdateCellPositionAtX:(CGFloat)x {
    return x < 0 && x > -(PAN_BUTTON_WIDTH * 2);
}

- (BOOL)canReleaseToTakeActionAtX:(CGFloat)x {
    return x > 0 || x < -(PAN_BUTTON_WIDTH * 2);
}

- (BOOL)shouldChangeImportanceAtX:(CGFloat)x {
    return x > 0;
}

- (BOOL)shouldDeleteAtX:(CGFloat)x {
    return x < -(PAN_BUTTON_WIDTH * 2);
}

@end
