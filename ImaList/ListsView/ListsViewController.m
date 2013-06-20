#import <QuartzCore/QuartzCore.h>
#import "ListsViewController.h"
#import "ListListDocument.h"
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListsViewController {
    BOOL editing;
    BOOL keyboardSizeSet;
    NSArray *editedLists;
    ListCollectionCell *cellToDelete;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self style];
    [self configureNotifications];
    editedLists = @[];
    UINib *cellNib = [UINib nibWithNibName:@"ListCollectionCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ListCell"];
    UINib *addCellNib = [UINib nibWithNibName:@"ListAddCell" bundle:nil];
    [_collectionView registerNib:addCellNib forCellWithReuseIdentifier:@"ListAddCell"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
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

#pragma mark - data

- (void)loadData {
    NSURL *docDir = [[[NSFileManager defaultManager]
                      URLsForDirectory:NSDocumentDirectory
                      inDomains:NSUserDomainMask] lastObject];
    NSURL *docURL = [docDir URLByAppendingPathComponent:@"ImaList.lists"];
    ListListDocument *doc = [[ListListDocument alloc] initWithFileURL:docURL];
    self.dataSource = doc;
    [doc openWithCompletionHandler:^(BOOL success) {
        if(success) {
            [_collectionView reloadData];
        } else {
            NSLog(@"Failed to open document");
        }
    }];
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource listCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.dataSource listAtIndex:indexPath.row];
    ListCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    [cell configureCellWithList:list editing:editing];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // go to list of items
}

#pragma mark - user actions

- (IBAction)addList:(id)sender {
    [self.dataSource createListWithName:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.dataSource listCount] - 1) inSection:0];
    [_collectionView insertItemsAtIndexPaths:@[indexPath]];
    ListCollectionCell *cell = (ListCollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [_collectionView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionRight
                                    animated:YES];
    [cell.listNameTextField becomeFirstResponder];
}

- (void)deleteListForCell:(ListCollectionCell *)cell {
    cellToDelete = cell;
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
        NSIndexPath *indexPath = [_collectionView indexPathForCell:cellToDelete];
        [self.dataSource deleteListAtIndex:indexPath.row];
        [self.dataSource commitChanges];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        cellToDelete = nil;
    }
}

#pragma mark - editing

- (void)toggleEditingMode {
    editing = !editing;
    if (editing) {
        [self showAddButton:nil];
    } else {
        [self hideAddButton:nil];
        [self finishEditing];
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

- (void)didFinishEditingList:(NSString *)listName cell:(ListCollectionCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    List *list = [self.dataSource listAtIndex:indexPath.row];
    list.name = listName;
}

- (void)finishEditing {
    [self.dataSource commitChanges];
}

#pragma mark - notifications

- (void)configureNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddButton:)
                                                 name:@"finishEditingList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideAddButton:)
                                                 name:@"beginEditingList"
                                               object:nil];
}

@end
