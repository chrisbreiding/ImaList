#import <QuartzCore/QuartzCore.h>
#import "ListsViewController.h"
#import "ListListDataSource.h"
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListsViewController {
    BOOL adding;
    BOOL editing;
    BOOL keyboardSizeSet;
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

- (void)willExit {
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
    if (editing) {
        List *list = [self.dataSource listAtIndex:indexPath.row];
        listBeingEdited = list;
        [self.delegate editListName:list.name];
    } else {
        // go to list of items
    }
}

#pragma mark - list list data source delegate

- (void)didCreateListAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)didUpdateListAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)didRemoveListAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - user actions

- (IBAction)addList:(id)sender {
    adding = YES;
    [self.delegate addList];
}

#pragma mark - list cell delegate

- (void)deleteList:(List *)list {
    listToDelete = list;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Delete list and all its items?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete List"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex ) {
        [self.dataSource removeList:listToDelete];
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
    }
}

@end
