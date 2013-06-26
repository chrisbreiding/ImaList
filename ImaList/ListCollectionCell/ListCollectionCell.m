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
    [self style];
    self.highlighted = current = isCurrent;
}

- (void)style {
    CALayer *layer = self.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = 0.8;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted || current) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        self.listNameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.25];
        self.listNameLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
}

#pragma mark - user actions

- (IBAction)didTapDelete:(id)sender {
    [self.delegate deleteList:self.list];
}

@end
