#import <UIKit/UIKit.h>
#import "ListListDataSource.h"
#import "ListCollectionCell.h"

@interface ListsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ListEditorDelegate>

@property (nonatomic, strong) id<ListListDataSource> dataSource;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
