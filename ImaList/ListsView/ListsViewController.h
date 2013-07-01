#import <UIKit/UIKit.h>
#import "ListListDataSource.h"
#import "ListCollectionCell.h"
#import "EditorViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@class Firebase;
@protocol ListsDelegate;

@interface ListsViewController : UIViewController <UICollectionViewDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout, UIActionSheetDelegate, ListCellDelegate, ListListDataSourceDelegate, EditorDelegate>

@property (nonatomic, weak) id<ListsDelegate> delegate;
@property (nonatomic, strong) ListListDataSource *dataSource;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL adding;

- (void)updateListsRef:(Firebase *)itemsRef;
- (void)toggleEditingMode;
- (void)didShow;
- (void)willHide;

@end

@protocol ListsDelegate <NSObject>

- (void)editListName:(NSString *)name;
- (void)didChangeListName:(NSString *)name;
- (void)displayItemsForList:(List *)list;

@end