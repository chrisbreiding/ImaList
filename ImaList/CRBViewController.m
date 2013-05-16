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
    [_editNameField removeFromSuperview];
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

- (void)addNameFieldToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CGRect editRect = CGRectMake(cell.textLabel.frame.origin.x, 0.0, cell.frame.size.width - cell.textLabel.frame.origin.x, cell.frame.size.height);
    if (_editNameField) {
        [self finishedEditingName];
        [_editNameField removeFromSuperview];
        [[[_tableView cellForRowAtIndexPath:_indexPathBeingEdited] textLabel] setHidden:NO];
    } else {
        _editNameField = [[UITextField alloc] init];
        _editNameField.font = cell.textLabel.font;
        _editNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
}

@end
