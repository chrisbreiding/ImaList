#import <UIKit/UIKit.h>
#import "ListListDataSource.h"

@interface ListsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) id<ListListDataSource> dataSource;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
