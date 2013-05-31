#import <QuartzCore/QuartzCore.h>
#import "CRBViewController.h"
#import "CRBItemListSource.h"
#import "CRBItem.h"
#import "CRBEditItemView.h"

@implementation CRBViewController {
    NSIndexPath *_indexPathBeingEdited;
    CRBEditItemView *_editItemView;
    UILabel *_tempLabel;
    UIImageView *_nameFieldBackground;
    UITextField *_nameField;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    [self styleButtons];
    [self addEditItemView];
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
    [self editNameForCell:cell isNew:NO];
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
    [self styleButton:self.sortItemsButton icon:@"icon-sort"];
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
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
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
    CRBItem *newItem = [self.dataSource createCountDownWithName:@" " checked:NO];
    NSUInteger row = [self.dataSource indexOfItem:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationNone];
    _indexPathBeingEdited = indexPath;
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
}

- (IBAction)sortItems:(id)sender {
    [self.dataSource sortItems];
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_indexPathBeingEdited && _indexPathBeingEdited.row == indexPath.row) {
        [self editNameForCell:cell isNew:YES];
        _indexPathBeingEdited = nil;
    }
}

- (void)checkmarkTapped:(id)gesture {
    int index = [[gesture view] tag];
    CRBItem *item = [self.dataSource itemAtIndex:index];
    BOOL isChecked = [item.isChecked boolValue];
    item.isChecked = @(!isChecked);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationLeft];
    [self.dataSource itemsChanged];
}

#pragma mark - edit mode

- (void)addEditItemView {
    _editItemView = [[CRBEditItemView alloc] initWithFrame:self.view.bounds];
    _editItemView.delegate = self;
    [self.view addSubview:_editItemView];
}

- (void)editNameForCell:(UITableViewCell *)cell isNew:(BOOL)isNew {
    [_editItemView showWithCell:cell
                         offset:_tableView.contentOffset.y
                          isNew:isNew];
}

- (void)didFinisheditingItemForCell:(UITableViewCell *)cell {
    CRBItem *item = [self.dataSource itemAtIndex:[[_tableView indexPathForCell:cell] row]];
    item.name = cell.textLabel.text;
}

@end
