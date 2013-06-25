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

- (instancetype)initWithFirebaseRef:(Firebase *)ref;

- (IBAction)addList:(id)sender;
- (void)toggleEditingMode;
- (void)willExit;

@end

@protocol ListsDelegate <NSObject>

- (void)addList;
- (void)editListName:(NSString *)name;

@end