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

- (instancetype)initWithFirebaseRef:(Firebase *)ref {
    self = [super init];
    if (self) {
        ListListDataSource *dataSource = [[ListListDataSource alloc] initWithFirebaseRef:ref];
        _dataSource = dataSource;
        dataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self style];
    
    UINib *cellNib = [UINib nibWithNibName:@"ListCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ListCell"];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)didShow {
    isShown = YES;
    [self.collectionView reloadData];
}

- (void)willHide {
    isShown = NO;
    editing = NO;
}

#pragma mark - style

- (void)style {
    self.backgroundImageView.image = [[UIImage imageNamed:@"lists-background"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)
                                      resizingMode:UIImageResizingModeStretch];
    CALayer *layer = self.addButton.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2;
    layer.shadowOpacity = 0.8;
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource listCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.dataSource listAtIndex:indexPath.row];
    ListCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWithList:list editing:editing];
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

- (void)didLoadLists {
    [self updateCurrentList:[self.dataSource listAtIndex:0]];
}

- (void)updateCurrentList:(List *)list {
    currentList = list;
    [self.delegate displayItemsForList:list];
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
    }
}

#pragma mark - user actions

- (IBAction)addList:(id)sender {
    adding = YES;
    [self.delegate addList];
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
        if ([currentList._id isEqualToString:listBeingEdited._id]) {
            [self.delegate didChangeListName:name];
        }
    }
}

@end
