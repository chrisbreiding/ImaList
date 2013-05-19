#import <QuartzCore/QuartzCore.h>
#import "CRBViewController.h"
#import "CRBItemListSource.h"
#import "CRBItem.h"

@implementation CRBViewController {
    NSIndexPath *_indexPathBeingEdited;
    UIView *_shadowboxView;
    UILabel *_tempLabel;
    UIImageView *_nameFieldBackground;
    UITextField *_nameField;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleView];
    [self styleNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self styleCell:cell];
    [self giveAttributesToCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _indexPathBeingEdited = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self editNameForCell:cell];
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditingName];
    return YES;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

#pragma mark - appearance

- (void)styleView {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)styleNavBar {
    self.navBarImageView.image = [[UIImage imageNamed:@"nav-bar.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0, 1.0, 0)];
    [self.listsButton setBackgroundImage:[[UIImage imageNamed:@"nav-bar-button.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)]
                                forState:UIControlStateNormal];
    [self.clearCompletedButton setBackgroundImage:[[UIImage imageNamed:@"nav-bar-button.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)]
                                forState:UIControlStateNormal];
}

- (void)styleCell:(UITableViewCell *)cell {
    UIImage *cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 44.0, 1.0, 0)];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithFrame:cell.frame];
    cellBackgroundView.image = cellBackgroundImage;
    cell.backgroundView = cellBackgroundView;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
}

#pragma mark - cell setup

- (void)giveAttributesToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CRBItem *item = [self.dataSource itemAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    NSString *checkImageName = @"unchecked.png";
    if ([item.isChecked boolValue]) {
        checkImageName = @"checked.png";
    }
    
    cell.imageView.image = [UIImage imageNamed:checkImageName];
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.tag = indexPath.row;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkmarkTapped:)];
    [cell.imageView setGestureRecognizers:@[gestureRecognizer]];
}

#pragma mark - user actions

- (IBAction)didPressClearCompleted:(id)sender {
    [self.dataSource clearCompleted];
    [self.tableView reloadData];
}

- (void)checkmarkTapped:(id)gesture {
    CRBItem *item = [self.dataSource itemAtIndex:[[gesture view] tag]];
    BOOL isChecked = [item.isChecked boolValue];
    item.isChecked = @(!isChecked);

    [self.dataSource itemsChanged];
    [self.tableView reloadData];
}

#pragma mark - edit mode

- (void)editNameForCell:(UITableViewCell *)cell {
    NSLog(@"    going: %@", NSStringFromCGRect(cell.frame));
    cell.textLabel.hidden = YES;
    
    UIView *shadowboxView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowboxView.backgroundColor = [UIColor blackColor];
    shadowboxView.alpha = 0;
    _shadowboxView = shadowboxView;
    [self.view addSubview:shadowboxView];
    
    CGFloat originX = cell.frame.origin.x + 54;
    CGFloat originY = cell.frame.origin.y + 50;
    CGFloat originWidth = cell.frame.size.width - 64;
    CGFloat originHeight = cell.frame.size.height;
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, originWidth, originHeight)];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = cell.textLabel.text;
    tempLabel.font = cell.textLabel.font;
    _tempLabel = tempLabel;
    [shadowboxView addSubview:tempLabel];
    
    UIImageView *nameFieldBackground = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, cell.bounds.size.height)];
    nameFieldBackground.image = [[UIImage imageNamed:@"textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    nameFieldBackground.alpha = 0;
    _nameFieldBackground = nameFieldBackground;
    [shadowboxView addSubview:nameFieldBackground];

    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 50, self.view.bounds.size.width - 60, cell.bounds.size.height)];
    nameField.text = cell.textLabel.text;
    nameField.textColor = [UIColor whiteColor];
    nameField.alpha = 0;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.delegate = self;
    _nameField = nameField;
    [shadowboxView addSubview:nameField];

    CGFloat destinationX = 30;
    CGFloat destinationY = 50;
    CGFloat destinationWidth = self.view.bounds.size.width - 60;
    CGFloat destinationHeight = cell.bounds.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        tempLabel.frame = CGRectMake(destinationX, destinationY, destinationWidth, destinationHeight);
        shadowboxView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            nameFieldBackground.alpha = 1;
            nameField.alpha = 1;
            tempLabel.alpha = 0;
        }];
        [nameField becomeFirstResponder];
    }];
}

- (void)endEditingName {
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPathBeingEdited];
    NSLog(@"returning: %@", NSStringFromCGRect(cell.frame));
    [_nameField resignFirstResponder];
    NSString *newName = _nameField.text;
    _tempLabel.text = newName;
    [UIView animateWithDuration:0.5 animations:^{
        _nameFieldBackground.alpha = 0;
        _nameField.alpha = 0;
        _tempLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat destinationX = cell.frame.origin.x + 54;
            CGFloat destinationY = cell.frame.origin.y + 50;
            CGFloat destinationWidth = cell.frame.size.width - 64;
            CGFloat destinationHeight = cell.frame.size.height;
            _tempLabel.frame = CGRectMake(destinationX, destinationY, destinationWidth, destinationHeight);
            _shadowboxView.alpha = 0;
        } completion:^(BOOL finished) {
            cell.textLabel.text = newName;
            cell.textLabel.hidden = NO;
            [_shadowboxView removeFromSuperview];
            _shadowboxView = nil;
            _nameField = nil;
            _nameFieldBackground = nil;
            _tempLabel = nil;
            _indexPathBeingEdited = nil;
        }];
    }];
    CRBItem *item = [self.dataSource itemAtIndex:[[_tableView indexPathForCell:cell] row]];
    item.name = newName;
}

@end
