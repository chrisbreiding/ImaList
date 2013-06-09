#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "ItemTableCell.h"
#import "ItemListSource.h"
#import "Item.h"
#import "EditItemView.h"

@implementation ViewController {
    EditItemView *_editItemView;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    [self styleButtons];
    [self addEditItemView];
    [self configureNotifications];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ItemCell";
    ItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configureCellWithItem:[self.dataSource itemAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableCell *cell = (ItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self editNameForCell:cell isNew:NO];
}

#pragma mark - cell notifications

-(void)configureNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadItemRow:)
                                                 name:@"reloadItemRow"
                                               object:nil];
}

-(void)reloadItemRow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfItem:userInfo[@"item"]]
                                                inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationMiddle];
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
    [button setBackgroundImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    button.titleLabel.text = @"";
}

#pragma mark - user actions

- (IBAction)didTapClearCompleted:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Clear Completed"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Clear Completed"]) {
        [self clearCompleted];
    }
}

- (void)clearCompleted {
    [self.dataSource clearCompleted];
    [self.tableView reloadData];    
}

- (IBAction)addItem:(id)sender {
    [_editItemView showForNewItem];
}

- (IBAction)sortItems:(id)sender {
    [self.dataSource sortItems];
    [_tableView reloadData];
}

#pragma mark - edit mode

- (void)addEditItemView {
    _editItemView = [[EditItemView alloc] initWithFrame:self.view.bounds];
    _editItemView.delegate = self;
    [self.view addSubview:_editItemView];
}

- (void)editNameForCell:(ItemTableCell *)cell isNew:(BOOL)isNew {
    [_editItemView showWithCell:cell
                         offset:_tableView.contentOffset.y];
}

- (void)didFinishEditingItemForCell:(ItemTableCell *)cell {
    Item *item = [self.dataSource itemAtIndex:[[_tableView indexPathForCell:cell] row]];
    item.name = cell.itemNameLabel.text;
}

- (void)didFinishAddingItem:(NSString *)itemName {
    Item *newItem = [self.dataSource createCountDownWithName:itemName checked:NO];
    NSUInteger row = [self.dataSource indexOfItem:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationNone];
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
}

@end
