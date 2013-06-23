#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "ItemTableCell.h"
#import "ItemListDataSource.h"
#import "Item.h"
#import "EditorViewController.h"
#import "ListsViewController.h"

@implementation ViewController {
    ListsViewController *listsVC;
    BOOL listsShown;
    BOOL editingList;
    NSLayoutConstraint *listsBottomConstraint;
    NSLayoutConstraint *listsHeightConstraint;
    EditorViewController *editItemVC;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addListsView];
    [self styleViews];
    [self styleButtons];
    [self addEditItemView];
    [self configureNotifications];
    UINib *cellNib = [UINib nibWithNibName:@"ItemTableCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"ItemTableCell"];
}

#pragma mark - data

- (void)loadData {
    self.dataSource = [[ItemListDataSource alloc] init];
}

#pragma mark - lists

- (void)addListsView {
    listsVC = [[ListsViewController alloc] init];
    UIView *listsView = listsVC.view;
    listsView.translatesAutoresizingMaskIntoConstraints = NO;
    listsView.hidden = YES;
    listsVC.collectionView.alpha = 0;
    self.editListsButton.hidden = YES;
    self.editListsButton.alpha = 0;
    [self.view addSubview:listsView];
    NSDictionary *views = NSDictionaryOfVariableBindings(listsView);
    NSArray *constraints = @[];
    NSArray *bottomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[listsView]-50-|"
                                                                   options:NSLayoutFormatAlignAllBaseline
                                                                   metrics:nil
                                                                     views:views];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[listsView(0)]"
                                                                         options:NSLayoutFormatAlignAllBaseline
                                                                         metrics:nil
                                                                           views:views];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[listsView]|"
                                                                             options:NSLayoutFormatAlignAllBaseline
                                                                             metrics:nil
                                                                               views:views];
    listsBottomConstraint = bottomConstraints[0];
    listsHeightConstraint = heightConstraints[0];
    constraints = [constraints arrayByAddingObjectsFromArray:bottomConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:heightConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:horizontalConstraints];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}

- (IBAction)toggleLists:(id)sender {
    if (listsShown) {
        [self hideLists];
    } else {
        [self showLists];
    }
}

- (void)showLists {
    [self toggleItemButtonsHidden:YES];
    listsVC.view.hidden = NO;
    self.editListsButton.hidden = NO;
    listsShown = YES;
    listsHeightConstraint.constant = 120;
    self.tableViewBottomConstraint.constant = 170;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
        self.editListsButton.alpha = 1;
    } completion:^(BOOL finished) {
        listsVC.view.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            listsVC.collectionView.alpha = 1;
        }];
    }];
}

- (void)hideLists {
    [self toggleItemButtonsHidden:NO];
    [listsVC willExit];
    [UIView animateWithDuration:0.2 animations:^{
        listsVC.collectionView.alpha = 0;
        self.editListsButton.alpha = 0;
    } completion:^(BOOL finished) {
        listsHeightConstraint.constant = 0;
        self.tableViewBottomConstraint.constant = 50;
        self.editListsButton.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            listsVC.view.hidden = YES;
            listsShown = NO;
        }];
    }];
}

- (void)toggleItemButtonsHidden:(BOOL)hidden {
    self.clearCompletedButton.hidden = hidden;
    self.sortItemsButton.hidden = hidden;
    self.addItemButton.hidden = hidden;
}

- (IBAction)toggleListEditingMode:(id)sender {
    [listsVC toggleEditingMode];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ItemTableCell";
    ItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWithItem:[self.dataSource itemAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableCell *cell = (ItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self editNameForCell:cell];
}

#pragma mark - notifications

-(void)configureNotifications {
    [self observeNotificationName:@"itemCreated" selector:@selector(itemCreated:)];
    [self observeNotificationName:@"itemChanged" selector:@selector(itemChanged:)];
    [self observeNotificationName:@"itemRemoved" selector:@selector(itemRemoved:)];
    
    [self observeNotificationName:@"beginEditingList" selector:@selector(beginEditingList:)];
    [self observeNotificationName:@"finishEditingList" selector:@selector(finishEditingList:)];
    [self observeNotificationName:UIKeyboardWillShowNotification selector:@selector(keyboardWillShow:)];
}

- (void)observeNotificationName:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:name
                                               object:nil];
}

- (void)itemCreated:(NSNotification *)notification {
    int row = [[notification userInfo][@"index"] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationTop];
}

- (void)itemChanged:(NSNotification *)notification {
    int row = [[notification userInfo][@"index"] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationMiddle];

}

- (void)itemRemoved:(NSNotification *)notification {
    int row = [[notification userInfo][@"index"] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView deleteRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)beginEditingList:(NSNotification *)notification {
    editingList = YES;
}

- (void)finishEditingList:(NSNotification *)notification {
    editingList = NO;
    listsBottomConstraint.constant = 50;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    int keyboardHeight = (int)[info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    if (editingList) {
        listsBottomConstraint.constant = keyboardHeight;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
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
    [self styleButton:self.listsButton icon:@"icon-lists"];
    [self styleButton:self.editListsButton icon:@"icon-edit-lists"];
    [self styleButton:self.addItemButton icon:@"icon-add"];
    [self styleButton:self.clearCompletedButton icon:@"icon-clear"];
    [self styleButton:self.sortItemsButton icon:@"icon-sort"];
}

- (void)styleButton:(UIButton *)button icon:(NSString *)iconName {
    [button setBackgroundImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    button.titleLabel.text = @"";
}

#pragma mark - user actions

- (IBAction)clearCompleted:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Clear Completed"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex ) {
        [self clearCompleted];
    }
}

- (void)clearCompleted {
    [self.dataSource clearCompleted];
}

- (IBAction)addItem:(id)sender {
    [editItemVC beginAddingMultipleItems];
}

- (IBAction)sortItems:(id)sender {
    [self.dataSource sortItems];
    [_tableView reloadData];
}

#pragma mark - item cell delegate

- (void)didUpdateItem:(Item *)item isChecked:(BOOL)isChecked {
    [self.dataSource updateItem:item isChecked:isChecked];
}

- (void)didDeleteItem:(Item *)item {
    [self.dataSource removeItem:item];
}

#pragma mark - edit mode

- (void)didFinishAddingItems:(NSArray *)itemNames {
    for (NSString *itemName in itemNames) {
        NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![trimmedName isEqualToString:@""]) {
            [self.dataSource createItemWithValues:@{ @"name": itemName, @"isChecked": @(NO) }];
        }
    }
}

- (void)addEditItemView {
    editItemVC = [[EditorViewController alloc] init];
    editItemVC.view.frame = self.view.bounds;
    editItemVC.delegate = self;
    [self.view addSubview:editItemVC.view];
}

- (void)editNameForCell:(ItemTableCell *)cell {
    [editItemVC beginEditingSingleItem:cell.item];
}

- (void)didFinishEditingItem:(Item *)item name:(NSString *)name {
    [self.dataSource updateItem:item name:name];
}

@end
