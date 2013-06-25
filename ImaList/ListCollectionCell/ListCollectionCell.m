#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    NSString *name;
    BOOL editing;
}

- (void)configureCellWithList:(List *)list editing:(BOOL)isEditing {
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
}

- (void)style {
    CALayer *layer = self.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = 0.8;
}

#pragma mark - user actions

- (IBAction)didTapDelete:(id)sender {
    [self.delegate deleteList:self.list];
}

@end
