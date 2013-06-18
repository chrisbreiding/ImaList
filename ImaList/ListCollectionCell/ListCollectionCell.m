#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    List *_list;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.listNameTextField.delegate = self;
}

- (void)configureCellWithList:(List *)list {
    self.listNameLabel.text = list.name;
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

- (void)enterEditMode {
    self.listNameTextField.text = self.listNameLabel.text;
    self.listNameTextField.hidden = NO;
    self.listNameLabel.hidden = YES;
}

- (void)exitEditMode {
    NSString *listName = self.listNameTextField.text;
    self.listNameLabel.text = listName;
    self.listNameTextField.hidden = YES;
    self.listNameLabel.hidden = NO;
    [self.delegate didFinishEditingList:listName cell:self];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self exitEditMode];
    [self.listNameTextField resignFirstResponder];
    return YES;
}

@end
