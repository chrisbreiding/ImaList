#import <QuartzCore/QuartzCore.h>
#import "ListsViewController.h"
#import "ListListDataSource.h"
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListsViewController {
    BOOL isShown;
    BOOL adding;
    BOOL editing;
    BOOL keyboardSizeSet;
    List *currentList;
    List *listBeingEdited;
    List *listToDelete;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UINib *cellNib = [UINib nibWithNibName:@"ListCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ListCell"];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)updateListsRef:(Firebase *)listsRef {
    ListListDataSource *dataSource = [[ListListDataSource alloc] initWithFirebaseRef:listsRef];
    _dataSource = dataSource;
    dataSource.delegate = self;
}

- (void)didShow {
    isShown = YES;
    [self.collectionView reloadData];
}

- (void)willHide {
    isShown = NO;
    editing = NO;
    [self hideAddButton:nil];
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource listCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.dataSource listAtIndex:indexPath.row];
    ListCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWithList:list editing:editing current:[list isEqualToList:currentList]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.dataSource listAtIndex:indexPath.row];
    if (editing) {
        listBeingEdited = list;
        [self.delegate editListName:list.name];
    } else {
        [self updateCurrentList:list];
    }
}

#pragma mark - list list data source delegate

- (void)updateCurrentList:(List *)list {
    if (![currentList isEqualToList:list]) {
        currentList = list;
        [self.delegate displayItemsForList:list];
        [self.dataSource storeCurrentList:list];
    }
}

- (void)didCreateListAtIndex:(int)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self updateCurrentList:[self.dataSource listAtIndex:index]];
    }
}

- (void)didUpdateListAtIndex:(int)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)didRemoveListAtIndex:(int)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        int switchTo = index > 0 ? index - 1 : 0;
        [self updateCurrentList:[self.dataSource listAtIndex:switchTo]];
    }
}

#pragma mark - user actions

- (IBAction)addList:(id)sender {
    adding = YES;
    [self.delegate addList];
}

- (IBAction)hide:(id)sender {
    [self.delegate hideLists];
}

#pragma mark - list cell delegate

- (void)deleteList:(List *)list {
    NSString *actionSheetTitle;
    NSString *destructiveButtonTitle = nil;
    if ([self.dataSource listCount] > 1) {
        listToDelete = list;
        actionSheetTitle = @"Delete list and all its items?";
        destructiveButtonTitle = @"Delete List";
    } else {
        actionSheetTitle = @"Cannot delete final list.";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:destructiveButtonTitle
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex ) {
        [self.dataSource removeList:listToDelete];
        listToDelete = nil;
    }
}

#pragma mark - editing

- (void)toggleEditingMode {
    editing = !editing;
    if (editing) {
        [self showAddButton:nil];
    } else {
        [self hideAddButton:nil];
    }
    [_collectionView reloadData];
}

- (void)showAddButton:(NSNotification *)notification {
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 60);
    self.addButtonTrailingConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideAddButton:(NSNotification *)notification {
    self.addButtonTrailingConstraint.constant = -50;
    [UIView animateWithDuration:0.2 animations:^{
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [self.view layoutIfNeeded];
    }];
}

- (void)didFinishEditingSingle:(NSString *)name {
    if (adding) {
        [self.dataSource createListWithName:name];
        adding = NO;
    } else {
        [self.dataSource updateList:listBeingEdited name:name];
        if ([currentList isEqualToList:listBeingEdited]) {
            [self.delegate didChangeListName:name];
        }
    }
}

@end
