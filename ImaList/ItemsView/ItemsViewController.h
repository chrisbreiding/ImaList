#import <UIKit/UIKit.h>
#import "ItemListDataSource.h"
#import "ItemTableCell.h"
#import "EditorViewController.h"

@class Firebase;
@protocol ItemsDelegate;

@interface ItemsViewController : UITableViewController <ItemCellDelegate, ItemListDataSourceDelegate, EditorDelegate>

@property (nonatomic, weak) id<ItemsDelegate> delegate;
@property (nonatomic, strong) ItemListDataSource *dataSource;

- (void)updateItemsRef:(Firebase *)itemsRef;
- (void)clearCompleted;
- (void)sortItems;

@end

@protocol ItemsDelegate <NSObject>

- (void)editItemName:(NSString *)name;

@end