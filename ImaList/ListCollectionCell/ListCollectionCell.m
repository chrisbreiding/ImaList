#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    NSString *name;
    BOOL editing;
    BOOL current;
}

- (void)configureCellWithList:(List *)list editing:(BOOL)isEditing current:(BOOL)isCurrent {
    [self style];
    self.list = list;
    self.listNameLabel.text = list.name;
    self.highlighted = current = isCurrent;

    if (isEditing) {
        self.deleteButton.hidden = NO;
        self.importantCountLabel.hidden = YES;
        editing = YES;
    }
    if (!isEditing && editing) {
        self.deleteButton.hidden = YES;
        editing = NO;
    }
    if (!isEditing && list.importantCount > 0) {
        self.importantCountLabel.text = [NSString stringWithFormat:@"%d", list.importantCount];
        self.importantCountLabel.hidden = NO;
    } else {
        self.importantCountLabel.hidden = YES;
    }
}

- (void)style {
    CALayer *layer = self.importantCountLabel.layer;
    layer.cornerRadius = self.importantCountLabel.frame.size.height / 2;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted || current) {
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.listNameLabel.textColor = [UIColor colorWithWhite:0.208 alpha:1];
    } else {
        self.bgView.backgroundColor = [UIColor colorWithRed:0.439 green:0.553 blue:0.145 alpha:1];
        self.listNameLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - user actions

- (IBAction)didTapDelete:(id)sender {
    [self.delegate deleteList:self.list];
}

@end
