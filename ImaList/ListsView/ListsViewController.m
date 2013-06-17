#import "ListsViewController.h"
#import "ListListDocument.h"
#import "ListCollectionCell.h"

@implementation ListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    UINib *cellNib = [UINib nibWithNibName:@"ListCollectionCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ListCell"];
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
    return [self.dataSource listCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    [cell configureCellWithList:[self.dataSource listAtIndex:indexPath.row]];
    return cell;
}

@end
