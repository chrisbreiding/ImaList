#import <UIKit/UIKit.h>
#import "ItemListDataSource.h"
#import "ItemTableCell.h"
#import "EditorViewController.h"

@protocol ItemsDelegate;

@interface ItemsViewController : UITableViewController <ItemCellDelegate, ItemListDataSourceDelegate, EditorDelegate>

@property (nonatomic, weak) id<ItemsDelegate> delegate;
@property (nonatomic, strong) ItemListDataSource *dataSource;

- (void)clearCompleted;
- (void)sortItems;

@end

@protocol ItemsDelegate <NSObject>

- (void)editNameForCell:(ItemTableCell *)cell;

@end