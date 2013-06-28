#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    NSString *name;
    BOOL editing;
    BOOL current;
}

- (void)configureCellWithList:(List *)list editing:(BOOL)isEditing current:(BOOL)isCurrent {
    self.list = list;
    self.listNameLabel.text = list.name;
    if (isEditing) {
        self.deleteButton.hidden = NO;
        editing = YES;
    }
    if (!isEditing && editing) {
        self.deleteButton.hidden = YES;
        editing = NO;
    }
    self.highlighted = current = isCurrent;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted || current) {
        self.backgroundColor = [UIColor whiteColor];
        self.listNameLabel.textColor = [UIColor colorWithWhite:0.208 alpha:1];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0.439 green:0.553 blue:0.145 alpha:1];
        self.listNameLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - user actions

- (IBAction)didTapDelete:(id)sender {
    [self.delegate deleteList:self.list];
}

@end
