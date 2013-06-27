#import <UIKit/UIKit.h>
#import "ListListDataSource.h"
#import "ListCollectionCell.h"
#import "EditorViewController.h"

@class Firebase;
@protocol ListsDelegate;

@interface ListsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, ListCellDelegate, ListListDataSourceDelegate, EditorDelegate>

@property (nonatomic, weak) id<ListsDelegate> delegate;
@property (nonatomic, strong) ListListDataSource *dataSource;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addButtonTrailingConstraint;

- (void)updateListsRef:(Firebase *)itemsRef;
- (IBAction)addList:(id)sender;
- (void)toggleEditingMode;
- (void)didShow;
- (void)willHide;

@end

@protocol ListsDelegate <NSObject>

- (void)addList;
- (void)editListName:(NSString *)name;
- (void)didChangeListName:(NSString *)name;
- (void)displayItemsForList:(List *)list;

@end