#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    List *_list;
    BOOL _editing;
    BOOL allExitEditing;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.listNameTextField.delegate = self;
}

- (void)configureCellWithList:(List *)list editing:(BOOL)editing {
    self.listNameLabel.text = list.name;
    if (editing) {
        [self enterEditingMode];
        _editing = YES;
    }
    if (!editing && _editing) {
        [self exitEditingMode];
        _editing = NO;
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
    self.listNameTextField.text = self.listNameLabel.text;
    self.listNameTextField.hidden = NO;
    self.deleteButton.hidden = NO;
    self.listNameLabel.hidden = YES;
}

- (void)exitEditingMode {
    NSLog(@"exit editing");
    NSString *listName = self.listNameTextField.text;
    self.listNameLabel.text = listName;        
    [self.delegate didFinishEditingList:listName cell:self];
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
    if (!_editing) {
        [self exitEditingMode];        
    }
    [self.listNameTextField resignFirstResponder];
    return YES;
}

@end
