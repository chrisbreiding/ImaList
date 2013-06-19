#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    NSString *name;
    BOOL editing;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.listNameTextField.delegate = self;
}

- (void)configureCellWithList:(List *)list editing:(BOOL)isEditing {
    if (isEditing) {
        self.listNameTextField.text = list.name;
        [self enterEditingMode];
        editing = YES;
    } else {
        self.listNameLabel.text = list.name;
    }
    if (!isEditing && editing) {
        [self exitEditingMode];
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

- (void)enterEditingMode {
    self.listNameTextField.hidden = NO;
    self.deleteButton.hidden = NO;
    self.listNameLabel.hidden = YES;
}

- (void)exitEditingMode {
    self.listNameTextField.hidden = YES;
    self.deleteButton.hidden = YES;
    self.listNameLabel.hidden = NO;
}

#pragma mark - user actions

- (IBAction)deleteList:(id)sender {
    [self.delegate deleteListForCell:self];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate didFinishEditingList:self.listNameTextField.text cell:self];
    [textField resignFirstResponder];
    return YES;
}

@end
