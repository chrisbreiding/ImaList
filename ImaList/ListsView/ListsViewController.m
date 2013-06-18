#import "ListsViewController.h"
#import "ListListDocument.h"
#import "ListCollectionCell.h"
#import "List.h"

@implementation ListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    UINib *cellNib = [UINib nibWithNibName:@"ListCollectionCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ListCell"];
    UINib *addCellNib = [UINib nibWithNibName:@"ListAddCell" bundle:nil];
    [_collectionView registerNib:addCellNib forCellWithReuseIdentifier:@"ListAddCell"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
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
    return [self.dataSource listCount] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListCollectionCell *cell;
    if (indexPath.row == [self.dataSource listCount]) {
        cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListAddCell" forIndexPath:indexPath];        
    } else {
        cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
        [cell configureCellWithList:[self.dataSource listAtIndex:indexPath.row]];
        cell.delegate = self;
        cell.tag = indexPath.row;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataSource listCount]) {
        [self.dataSource createListWithName:@""];
        NSIndexPath *newAddIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
        [_collectionView insertItemsAtIndexPaths:@[indexPath]];
        [_collectionView reloadItemsAtIndexPaths:@[newAddIndexPath]];
        ListCollectionCell *cell = (ListCollectionCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        [cell enterEditMode];
        [cell.listNameTextField becomeFirstResponder];
    } else {
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataSource listCount]) {
        return CGSizeMake(50, 100);
    } else {
        return CGSizeMake(100, 100);
    }
}

#pragma mark - list editor delegate

- (void)didFinishEditingList:(NSString *)listName cell:(ListCollectionCell *)cell {
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    List *list = [self.dataSource listAtIndex:indexPath.row];
    list.name = listName;
    [self.dataSource commitChanges];
}

@end
