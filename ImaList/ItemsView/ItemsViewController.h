#import <UIKit/UIKit.h>
#import "ItemListDataSource.h"
#import "ItemTableCell.h"
#import "EditorViewController.h"

@class Firebase;
@protocol ItemsDelegate;

@interface ItemsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ItemCellDelegate, ItemListDataSourceDelegate, EditorDelegate>

@property (nonatomic, weak) id<ItemsDelegate> delegate;
@property (nonatomic, strong) ItemListDataSource *dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextView *noItemsTextView;

- (IBAction)addItem:(id)sender;
- (void)updateItemsRef:(Firebase *)itemsRef;
- (void)clearCompleted;
- (void)sortItems;

@end

@protocol ItemsDelegate <NSObject>

- (void)addItem;
- (void)editItemName:(NSString *)name;

@end