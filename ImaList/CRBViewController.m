#import <QuartzCore/QuartzCore.h>
#import "CRBViewController.h"
#import "CRBItemListSource.h"
#import "CRBItem.h"

static CGFloat cellHeight = 50;

static CGFloat cellX = 60;
static CGFloat cellWidth;

static CGFloat nameFieldX = 30;
static CGFloat nameFieldY = 50;
static CGFloat nameFieldWidth;

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
    [self styleViews];
    [self styleButtons];
    cellWidth = self.view.frame.size.width - (cellX * 2);
    nameFieldWidth = self.view.bounds.size.width - (nameFieldX * 2);
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

#pragma mark - appearance

- (void)styleViews {
    UIImage *navbarBackground = [[UIImage imageNamed:@"nav-bar"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.navBarView.layer setContents:(id)[navbarBackground CGImage]];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    UIImage *footerBackground = [[UIImage imageNamed:@"footer"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.footerView.layer setContents:(id)[footerBackground CGImage]];
}

- (void)styleButtons {
    [self styleButton:self.listsButton icon:@"icon-list"];
    [self styleButton:self.addItemButton icon:@"icon-add"];
    [self styleButton:self.clearCompletedButton icon:@"icon-clear"];
}

- (void)styleButton:(UIButton *)button icon:(NSString *)iconName {
    [button setBackgroundImage:[[UIImage imageNamed:@"nav-bar-button"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                forState:UIControlStateNormal];
    
    CALayer *iconLayer = [CALayer layer];
    iconLayer.frame = CGRectMake(0, 0, 36, 36);
    [iconLayer setContents:(id)[[UIImage imageNamed:iconName] CGImage]];
    [button.layer addSublayer:iconLayer];
    
    button.titleLabel.text = @"";
}

- (void)styleCell:(UITableViewCell *)cell {
    UIImage *cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 51, 1, 0)];
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

- (IBAction)clearCompleted:(id)sender {
    [self.dataSource clearCompleted];
    [self.tableView reloadData];
}

- (IBAction)addItem:(id)sender {
    NSLog(@"add new item");
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
    UIView *shadowboxView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowboxView.backgroundColor = [UIColor blackColor];
    shadowboxView.alpha = 0;
    _shadowboxView = shadowboxView;
    [self.view addSubview:shadowboxView];

    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDownOnShadowbox:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [_shadowboxView setGestureRecognizers:@[swipeRecognizer]];
    
    CGFloat cellY = cell.frame.origin.y + 50 - _tableView.contentOffset.y;
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY, cellWidth, cellHeight)];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = cell.textLabel.text;
    tempLabel.font = cell.textLabel.font;
    _tempLabel = tempLabel;
    [shadowboxView addSubview:tempLabel];
    
    UIImageView *nameFieldBackground = [[UIImageView alloc] initWithFrame:CGRectMake(nameFieldX - 10, nameFieldY, nameFieldWidth, cellHeight)];
    nameFieldBackground.image = [[UIImage imageNamed:@"textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    nameFieldBackground.alpha = 0;
    _nameFieldBackground = nameFieldBackground;
    [shadowboxView addSubview:nameFieldBackground];

    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(nameFieldX, nameFieldY, nameFieldWidth, cellHeight)];
    nameField.text = cell.textLabel.text;
    nameField.font = cell.textLabel.font;
    nameField.textColor = [UIColor whiteColor];
    nameField.alpha = 0;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.delegate = self;
    _nameField = nameField;
    [shadowboxView addSubview:nameField];

    [UIView animateWithDuration:0.2 animations:^{
        shadowboxView.alpha = 0.8;
        tempLabel.textColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        cell.textLabel.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            tempLabel.frame = CGRectMake(nameFieldX, nameFieldY, nameFieldWidth, cellHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                nameFieldBackground.alpha = 1;
                nameField.alpha = 1;
                tempLabel.alpha = 0;
            }];
            [nameField becomeFirstResponder];
        }];
    }];
}

- (void)endEditingName {
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPathBeingEdited];
    [_nameField resignFirstResponder];
    NSString *newName = _nameField.text;
    _tempLabel.text = newName;
    cell.textLabel.text = newName;
    [UIView animateWithDuration:0.2 animations:^{
        _nameFieldBackground.alpha = 0;
        _nameField.alpha = 0;
        _tempLabel.alpha = 1;        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat cellY = cell.frame.origin.y + 50 - _tableView.contentOffset.y;
            _tempLabel.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        } completion:^(BOOL finished) {
            cell.textLabel.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                _shadowboxView.alpha = 0;
                _tempLabel.textColor = [UIColor blackColor];
            } completion:^(BOOL finished) {
                [_shadowboxView removeFromSuperview];
                _shadowboxView = nil;
                _nameField = nil;
                _nameFieldBackground = nil;
                _tempLabel = nil;
                _indexPathBeingEdited = nil;
            }];
        }];
    }];
    CRBItem *item = [self.dataSource itemAtIndex:[[_tableView indexPathForCell:cell] row]];
    item.name = newName;
}

- (void)didSwipeDownOnShadowbox:(UISwipeGestureRecognizer *)sender {
    [self endEditingName];
}

@end
