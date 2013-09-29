#import <QuartzCore/QuartzCore.h>
#import "ListsViewController.h"
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListsViewController {
    BOOL isShown;
    BOOL editing;
    BOOL keyboardSizeSet;
    List *currentList;
    List *listBeingEdited;
    List *listToDelete;
    NSNumber *fromIndexForMove;
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
    [self.collectionView reloadData];
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

#pragma mark - reorderable data source

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
}

#pragma mark - reorderable delegate flow layout

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    fromIndexForMove = @(indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger fromInt = [fromIndexForMove intValue];
    NSUInteger toInt = indexPath.row;
    if (fromIndexForMove && fromInt != toInt) {
        [self.dataSource moveListFromIndex:fromInt toIndex:toInt];
        fromIndexForMove = nil;
    }
}

#pragma mark - list list data source delegate

- (void)updateCurrentList:(List *)list {
    if (![currentList isEqualToList:list]) {
        currentList = list;
        [self.delegate displayItemsForList:list];
        [self.dataSource storeCurrentList:list];
        [self.collectionView reloadData];
    }
}

- (void)didCreateListAtIndex:(NSUInteger)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self updateCurrentList:[self.dataSource listAtIndex:index]];
    }
}

- (void)didUpdateListAtIndex:(NSUInteger)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)didSortLists {
    [self.collectionView reloadData];
}

- (void)didRemoveListAtIndex:(NSUInteger)index {
    if (isShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        int switchTo = index > 0 ? index - 1 : 0;
        [self updateCurrentList:[self.dataSource listAtIndex:switchTo]];
    }
}

#pragma mark - list cell delegate

- (void)deleteList:(List *)list {
    NSString *optionsTitle;
    NSString *primaryButtonTitle = nil;
    if ([self.dataSource listCount] > 1) {
        listToDelete = list;
        optionsTitle = @"Delete list and all its items?";
        primaryButtonTitle = @"Delete List";
    } else {
        optionsTitle = @"Cannot delete final list.";
    }
    OptionsView *optionsView = [[OptionsView alloc] initWithTitle:optionsTitle
                                                         delegate:self
                                               primaryButtonTitle:primaryButtonTitle
                                                cancelButtonTitle:@"Cancel"];
    [optionsView showInView:self.view.superview.superview];
}

- (void)primaryActionChosenForOptionsView:(OptionsView *)optionsView {
    [self.dataSource removeList:listToDelete];
    listToDelete = nil;
}

#pragma mark - editing

- (void)toggleEditingMode {
    editing = !editing;
    [_collectionView reloadData];
}

- (void)didFinishEditingSingle:(NSString *)name {
    if (self.adding) {
        [self.dataSource createListWithName:name];
        self.adding = NO;
    } else {
        [self.dataSource updateList:listBeingEdited name:name];
        if ([currentList isEqualToList:listBeingEdited]) {
            [self.delegate didChangeListName:name];
        }
    }
}

@end
