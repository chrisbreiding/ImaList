#import <QuartzCore/QuartzCore.h>
#import <Firebase/Firebase.h>
#import <FirebaseAuthClient/FirebaseAuthClient.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "ListsViewController.h"
#import "List.h"
#import "ItemsViewController.h"
#import "Item.h"
#import "EditorViewController.h"

@implementation MainViewController {
    ListsViewController *listsVC;
    ItemsViewController *itemsVC;
    EditorViewController *editorVC;
    BOOL listsShown;
    BOOL editingList;
    NSLayoutConstraint *listsHeightConstraint;
    NSLayoutConstraint *itemsBottomConstraint;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addItemsView];
    [self addListsView];
    [self addEditorView];
    
    [self styleViews];
    [self styleButtons];
    
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com"];
    FirebaseAuthClient* authClient = [[FirebaseAuthClient alloc] initWithRef:ref];
    [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            NSLog(@"error while checking authentication");
        } else if (user == nil) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - lists

- (void)addListsView {
    listsVC = [[ListsViewController alloc] initWithFirebaseRef:[[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com/lists"]];
    listsVC.delegate = self;
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
    listsHeightConstraint = heightConstraints[0];
    constraints = [constraints arrayByAddingObjectsFromArray:bottomConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:heightConstraints];
    constraints = [constraints arrayByAddingObjectsFromArray:horizontalConstraints];
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}

- (IBAction)toggleLists:(id)sender {
    if (listsShown) {
        [self hideListsCompletion:nil];
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
        } completion:^(BOOL finished) {
            [listsVC didShow];
        }];
    }];
}

- (void)hideListsCompletion:(void (^)())completion {
    [listsVC willHide];
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
            if (completion) completion();
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
    itemsVC = [[ItemsViewController alloc] init];
    itemsVC.delegate = self;
    UIView *itemsView = itemsVC.view;
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

- (void)displayItemsForList:(List *)list {
    self.listNameLabel.text = list.name;
    [self hideListsCompletion:^{
        [itemsVC updateItemsRef:[list.ref childByAppendingPath:@"items"]];
    }];
}

#pragma mark - editor

-(void)addEditorView {
    editorVC = [[EditorViewController alloc] init];
    editorVC.view.frame = self.view.bounds;
    editorVC.delegate = itemsVC;
    [self.view addSubview:editorVC.view];
}

- (void)addList {
    editorVC.delegate = listsVC;
    [editorVC beginEditingSingle:@""];
}

- (void)editListName:(NSString *)name {
    editorVC.delegate = listsVC;
    [editorVC beginEditingSingle:name];
}

- (void)didChangeListName:(NSString *)name {
    self.listNameLabel.text = name;
}

- (IBAction)addItem:(id)sender {
    editorVC.delegate = itemsVC;
    [editorVC beginEditingMultiple];
}

- (void)editItemName:(NSString *)name {
    editorVC.delegate = itemsVC;
    [editorVC beginEditingSingle:name];
}

#pragma mark - convenience

- (NSArray *)constraintWithString:(NSString *)constraintString views:(NSDictionary *)views {
    return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                   options:NSLayoutFormatAlignAllBaseline
                                                   metrics:nil
                                                     views:views];

}

@end
