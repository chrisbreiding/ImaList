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
    BOOL initialAuthCheck;
    BOOL listsShown;
    BOOL editingList;
    NSLayoutConstraint *itemsBottomConstraint;
}

# pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addItemsView];
    [self addListsView];
    [self addEditorView];

    [self checkAuthentication];
}

- (void)checkAuthentication {
    Firebase* ref = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com"];
    FirebaseAuthClient* authClient = [[FirebaseAuthClient alloc] initWithRef:ref];
    [authClient checkAuthStatusWithBlock:^(NSError* error, FAUser* user) {
        if (error != nil) {
            NSLog(@"error while checking authentication: %@", error);
        } else if (user == nil) {
            [self openLogin];
        }
    }];
    
    Firebase* authRef = [ref.root childByAppendingPath:@".info/authenticated"];
    [authRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot* authenticated) {
        if ([authenticated.value boolValue]) {
            [self closeLogin];
        } else {
            if (initialAuthCheck) {
                [self openLogin];
            } else {
                initialAuthCheck = YES;
            }
        }
    }];
}

- (void)openLogin {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)closeLogin {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [listsVC updateListsRef:[[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com/lists"]];
}

#pragma mark - lists

- (void)addListsView {
    listsVC = [[ListsViewController alloc] init];
    listsVC.delegate = self;
    UIView *listsView = listsVC.view;
    listsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.footerView addSubview:listsView];
    NSDictionary *views = NSDictionaryOfVariableBindings(listsView);
    NSArray *constraints = [self constraintWithString:@"V:|-50-[listsView(120)]" views:views];
    NSArray *horizontalConstraints = [self constraintWithString:@"H:|[listsView]|" views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:horizontalConstraints];
    [self.footerView addConstraints:constraints];
}

- (IBAction)toggleLists:(id)sender {
    if (listsShown) {
        [self hideListsCompletion:nil];
    } else {
        [self showLists:nil];
    }
}

- (void)showLists:(id)sender {
    listsShown = YES;
    self.footerBottomConstraint.constant = 0;
    itemsBottomConstraint.constant = 170;
    [UIView animateWithDuration:0.3 animations:^{
        [self toggleButtonsListShown:YES];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [listsVC didShow];
    }];
}

- (IBAction)hideLists:(id)sender {
    editingList = NO;
    [self toggleEditIcon];
    [self hideListsCompletion:nil];
}

- (void)hideListsCompletion:(void (^)())completion {
    [listsVC willHide];
    self.footerBottomConstraint.constant = -120;
    itemsBottomConstraint.constant = 50;
    [UIView animateWithDuration:0.3 animations:^{
        [self toggleButtonsListShown:NO];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        listsShown = NO;
        if (completion) completion();
    }];
}

- (void)toggleButtonsListShown:(BOOL)shown {
    int listAlpha = shown ? 1 : 0;
    self.editListsButton.alpha = listAlpha;
    self.addListButton.alpha = listAlpha;
    int itemAlpha = shown ? 0 : 1;
    self.clearCompletedButton.alpha = itemAlpha;
    self.sortItemsButton.alpha = itemAlpha;
    self.addItemButton.alpha = itemAlpha;
}

- (IBAction)toggleListEditingMode:(id)sender {
    editingList = !editingList;
    [self toggleEditIcon];
    [listsVC toggleEditingMode];
}

- (void)toggleEditIcon {
    NSString *editIconName = editingList ? @"icon-editing-lists" : @"icon-edit-lists";
    [self.editListsButton setBackgroundImage:[UIImage imageNamed:editIconName] forState:UIControlStateNormal];
}

- (IBAction)addList:(id)sender {
    listsVC.adding = YES;
    editorVC.delegate = listsVC;
    [editorVC beginEditingSingle:@""];
}

#pragma mark - items

- (void)addItemsView {
    itemsVC = [[ItemsViewController alloc] init];
    itemsVC.delegate = self;
    UIView *itemsView = itemsVC.view;
    itemsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:itemsView atIndex:0];
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

- (void)editListName:(NSString *)name {
    editorVC.delegate = listsVC;
    [editorVC beginEditingSingle:name];
}

- (void)didChangeListName:(NSString *)name {
    self.listNameLabel.text = name;
}

- (void)addItem {
    [self addItem:nil];
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
