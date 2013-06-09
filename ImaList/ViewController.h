#import <UIKit/UIKit.h>
#import "ItemListDataSource.h"
#import "EditItemView.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditItemViewDelegate>

@property (nonatomic, strong) id<ItemListDataSource> dataSource;

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *listsButton;
@property (nonatomic, weak) IBOutlet UIButton *clearCompletedButton;
@property (nonatomic, weak) IBOutlet UIButton *addItemButton;
@property (nonatomic, weak) IBOutlet UIButton *sortItemsButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction) clearCompleted:(id)sender;
- (IBAction) addItem:(id)sender;
- (IBAction) sortItems:(id)sender;

@end
