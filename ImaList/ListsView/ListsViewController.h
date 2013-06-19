#import <UIKit/UIKit.h>
#import "ListListDataSource.h"
#import "ListCollectionCell.h"

@interface ListsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, ListEditorDelegate>

@property (nonatomic, strong) id<ListListDataSource> dataSource;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonTrailingConstraint;

- (IBAction)addList:(id)sender;
- (void)toggleEditingMode;
- (void)willExit;

@end
