#import "CRBViewController.h"
#import "CRBItemListSource.h"
#import "CRBItem.h"

@implementation CRBViewController {
    NSIndexPath *_indexPathBeingEdited;
    UITextField *_editNameField;
}

# pragma marl - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleView];
    [self styleNavBar];

    // post notification to add insets when keyboard is shown
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.hidden = YES;
    
    [self addNameFieldToCell:cell atIndexPath:indexPath];
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self finishedEditingName];
    _editNameField = nil;
    return YES;
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
    [cell.imageView setGestureRecognizers:@[]];
    [cell.imageView addGestureRecognizer:gestureRecognizer];
}

#pragma mark - user actions

- (IBAction)didPressClearCompleted:(id)sender {
    if (_editNameField) {
        [self finishedEditingName];
        _editNameField = nil;
    }
    [self.dataSource clearCompleted];
    [self.tableView reloadData];
}

- (void)checkmarkTapped:(id)gesture {
    CRBItem *item = [self.dataSource itemAtIndex:[[gesture view] tag]];
    BOOL isChecked = [item.isChecked boolValue];
    
    item.isChecked = @(!isChecked);

    if (_editNameField) {
        [self finishedEditingName];
        _editNameField = nil;
    }
    
    [self.dataSource itemsChanged];
    [self.tableView reloadData];
}

#pragma mark - edit mode

- (void)addNameFieldToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CGRect editRect = CGRectMake(cell.textLabel.frame.origin.x, 0.0, cell.frame.size.width - cell.textLabel.frame.origin.x, cell.frame.size.height);
    if (_editNameField) {
        [self finishedEditingName];
    } else {
        _editNameField = [[UITextField alloc] init];
        _editNameField.font = cell.textLabel.font;
        _editNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _editNameField.returnKeyType = UIReturnKeyDone;
    }    
    _indexPathBeingEdited = indexPath;
    _editNameField.frame = editRect;
    _editNameField.text = cell.textLabel.text;
    _editNameField.delegate = self;
    [cell addSubview:_editNameField];
    [_editNameField becomeFirstResponder];
}

- (void)finishedEditingName {
    CRBItem *item = [self.dataSource itemAtIndex:_indexPathBeingEdited.row];
    item.name = _editNameField.text;

    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPathBeingEdited];
    cell.textLabel.text = _editNameField.text;
    cell.textLabel.hidden = NO;

    [_editNameField removeFromSuperview];
    [[[_tableView cellForRowAtIndexPath:_indexPathBeingEdited] textLabel] setHidden:NO];
}

#pragma mark - keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
	// keyboard frame is in window coordinates
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
	// convert own frame to window coordinates, frame is in superview's coordinates
	CGRect ownFrame = [_tableView.window convertRect:_tableView.frame
                                            fromView:_tableView.superview];
    
	// calculate the area of own frame that is covered by keyboard
	CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);
    
	// now this might be rotated, so convert it back
	coveredFrame = [_tableView.window convertRect:coveredFrame
                                           toView:_tableView.superview];
    
	// set inset to make up for covered array at bottom
	_tableView.contentInset = UIEdgeInsetsMake(0, 0, coveredFrame.size.height, 0);
	_tableView.scrollIndicatorInsets = _tableView.contentInset;

    [_tableView scrollToRowAtIndexPath:_indexPathBeingEdited
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
	_tableView.scrollIndicatorInsets = _tableView.contentInset;
}

@end
