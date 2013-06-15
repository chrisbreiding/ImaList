#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "ItemTableCell.h"
#import "ItemListSource.h"
#import "Item.h"
#import "EditorViewController.h"

@implementation ViewController {
    EditorViewController *editItemVC;
    ItemTableCell *cellBeingEdited;
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
    [self editNameForCell:cell];
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
                      withRowAnimation:UITableViewRowAnimationNone];
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
    [self styleButton:self.addMultipleItemsButton icon:@"icon-add-multiple"];
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
    [editItemVC beginAddingSingleItem];
}

- (IBAction)addMultipleItems:(id)sender {
    [editItemVC beginAddingMultipleItems];
}

- (IBAction)sortItems:(id)sender {
    [self.dataSource sortItems];
    [_tableView reloadData];
}

#pragma mark - edit mode

- (void)addEditItemView {
    editItemVC = [[EditorViewController alloc] init];
    editItemVC.view.frame = self.view.bounds;
    editItemVC.delegate = self;
    [self.view addSubview:editItemVC.view];
}

- (void)editNameForCell:(ItemTableCell *)cell {
    cellBeingEdited = cell;
    [editItemVC beginEditingSingleItem:cell.itemNameLabel.text];
}

- (void)didFinishEditingItem:(NSString *)itemName {
    Item *item = [self.dataSource itemAtIndex:[[_tableView indexPathForCell:cellBeingEdited] row]];
    item.name = itemName;
    cellBeingEdited.itemNameLabel.text = itemName;
    cellBeingEdited = nil;
}

- (void)didFinishAddingItem:(NSString *)itemName {
    Item *newItem = [self.dataSource createCountDownWithName:itemName checked:NO];
    NSUInteger row = [self.dataSource indexOfItem:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationRight];
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
}

- (void)didFinishAddingMultipleItems:(NSArray *)itemNames {
    NSMutableArray *indexPaths = [NSMutableArray array];
    Item *newItem;
    NSUInteger row;
    NSIndexPath *indexPath;
    for (NSString *itemName in itemNames) {
        NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![trimmedName isEqualToString:@""]) {
            newItem = [self.dataSource createCountDownWithName:itemName checked:NO];
            row = [self.dataSource indexOfItem:newItem];
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:indexPath];            
        }
    }
    [_tableView insertRowsAtIndexPaths:indexPaths
                      withRowAnimation:UITableViewRowAnimationTop];
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
    
}

@end
