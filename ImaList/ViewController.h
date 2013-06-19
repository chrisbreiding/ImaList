#import <UIKit/UIKit.h>
#import "ItemListDataSource.h"
#import "EditorViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, EditorDelegate>

@property (nonatomic, strong) id<ItemListDataSource> dataSource;

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *listsButton;
@property (nonatomic, weak) IBOutlet UIButton *editListsButton;
@property (nonatomic, weak) IBOutlet UIButton *clearCompletedButton;
@property (nonatomic, weak) IBOutlet UIButton *addItemButton;
@property (nonatomic, weak) IBOutlet UIButton *sortItemsButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

- (IBAction) clearCompleted:(id)sender;
- (IBAction) addItem:(id)sender;
- (IBAction) sortItems:(id)sender;
- (IBAction) toggleLists:(id)sender;
- (IBAction) toggleListEditingMode:(id)sender;

@end
