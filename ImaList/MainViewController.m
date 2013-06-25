#import <QuartzCore/QuartzCore.h>
#import <Firebase/Firebase.h>
#import "MainViewController.h"
#import "ItemsViewController.h"
#import "ItemListDataSource.h"
#import "Item.h"
#import "EditorViewController.h"
#import "ListsViewController.h"

@implementation MainViewController {
    ListsViewController *listsVC;
    ItemsViewController *itemsVC;
    EditorViewController *editorVC;
    BOOL listsShown;
    BOOL editingList;
    NSLayoutConstraint *listsBottomConstraint;
    NSLayoutConstraint *listsHeightConstraint;
    NSLayoutConstraint *itemsBottomConstraint;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addItemsView];
    [self addListsView];
    [self addEditItemView];
    
    [self styleViews];
    [self styleButtons];
    [self configureNotifications];
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
    NSArray *bottomConstraints = [self constraintWithString:@"V:[listsView]-50-|" views:views];
    NSArray *heightConstraints = [self constraintWithString:@"V:[listsView(0)]" views:views];
    NSArray *horizontalConstraints = [self constraintWithString:@"H:|[listsView]|" views:views];
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
    listsVC.view.hidden = NO;
    self.editListsButton.hidden = NO;
    listsShown = YES;
    listsHeightConstraint.constant = 120;
    itemsBottomConstraint.constant = 170;
    [UIView animateWithDuration:0.2 animations:^{
        [self toggleItemButtonsHidden:YES];
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
    [listsVC willExit];
    [UIView animateWithDuration:0.2 animations:^{
        listsVC.collectionView.alpha = 0;
        self.editListsButton.alpha = 0;
    } completion:^(BOOL finished) {
        listsHeightConstraint.constant = 0;
        itemsBottomConstraint.constant = 50;
        self.editListsButton.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self toggleItemButtonsHidden:NO];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            listsVC.view.hidden = YES;
            listsShown = NO;
        }];
    }];
}

- (void)toggleItemButtonsHidden:(BOOL)hidden {
    int alpha = hidden ? 0 : 1;
    self.clearCompletedButton.alpha = alpha;
    self.sortItemsButton.alpha = alpha;
    self.addItemButton.alpha = alpha;
}

- (IBAction)toggleListEditingMode:(id)sender {
    [listsVC toggleEditingMode];
}

#pragma mark - items

- (void)addItemsView {
    itemsVC = [[ItemsViewController alloc] initWithFirebaseRef:[[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com/items"]];
    itemsVC.delegate = self;
    UITableView *itemsView = itemsVC.tableView;
    itemsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:itemsView];
    NSDictionary *views = NSDictionaryOfVariableBindings(itemsView);
    NSArray *constraints = @[];
    NSArray *bottomConstraints = [self constraintWithString:@"V:[itemsView]-50-|" views:views];
    NSArray *heightConstraints = [self constraintWithString:@"V:|-50-[itemsView]" views:views];
    NSArray *horizontalConstraints = [self constraintWithString:@"H:|[itemsView]|" views:views];
    itemsBottomConstraint = bottomConstraints[0];
    constraints = [constraints arrayByAddingObjectsFromArray:bottomConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:heightConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:horizontalConstraints];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}

#pragma mark - notifications

-(void)configureNotifications {
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
        [itemsVC clearCompleted];
    }
}

- (IBAction)sortItems:(id)sender {
    [itemsVC sortItems];
}

#pragma mark - item editing

- (IBAction)addItem:(id)sender {
    [editorVC beginAddingMultipleItems];
}

- (void)addEditItemView {
    editorVC = [[EditorViewController alloc] init];
    editorVC.view.frame = self.view.bounds;
    editorVC.delegate = itemsVC;
    [self.view addSubview:editorVC.view];
}

- (void)editNameForCell:(ItemTableCell *)cell {
    [editorVC beginEditingSingleItem:cell.item];
}

#pragma mark - convenience

- (NSArray *)constraintWithString:(NSString *)constraintString views:(NSDictionary *)views {
    return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                   options:NSLayoutFormatAlignAllBaseline
                                                   metrics:nil
                                                     views:views];

}

@end
