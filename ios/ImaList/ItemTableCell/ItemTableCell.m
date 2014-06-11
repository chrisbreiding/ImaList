#import "ItemTableCell.h"
#import "Item.h"
#import "ItemPanHandler.h"

@implementation ItemTableCell {
    ItemPanHandler *panHandler;
}

-(void)awakeFromNib {
    [super awakeFromNib];
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
