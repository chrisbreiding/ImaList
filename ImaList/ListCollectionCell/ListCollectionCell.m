#import <QuartzCore/QuartzCore.h>
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell {
    NSString *name;
    BOOL editing;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureNotifications];
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

#pragma mark - notifications

- (void)configureNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDeleteButton:)
                                                 name:@"finishEditingList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideDeleteButton:)
                                                 name:@"beginEditingList"
                                               object:nil];
}

- (void)showDeleteButton:(NSNotification *)notification {
    self.deleteButton.hidden = NO;
}

- (void)hideDeleteButton:(NSNotification *)notification {
    self.deleteButton.hidden = YES;
}

#pragma mark - user actions

- (IBAction)deleteList:(id)sender {
    [self.delegate deleteListForCell:self];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginEditingList" object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate didFinishEditingList:self.listNameTextField.text cell:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishEditingList" object:nil];
    [textField resignFirstResponder];
    return YES;
}

@end
