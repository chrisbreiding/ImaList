#import <UIKit/UIKit.h>
#import "ListsViewController.h"
#import "ItemsViewController.h"
#import "EditorViewController.h"

@interface MainViewController : UIViewController <UIActionSheetDelegate, ItemsDelegate, ListsDelegate>

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *listsButton;
@property (nonatomic, weak) IBOutlet UIButton *editListsButton;
@property (nonatomic, weak) IBOutlet UIButton *clearCompletedButton;
@property (nonatomic, weak) IBOutlet UIButton *addItemButton;
@property (nonatomic, weak) IBOutlet UIButton *sortItemsButton;

- (IBAction) clearCompleted:(id)sender;
- (IBAction) addItem:(id)sender;
- (IBAction) sortItems:(id)sender;
- (IBAction) toggleLists:(id)sender;
- (IBAction) toggleListEditingMode:(id)sender;

@end
