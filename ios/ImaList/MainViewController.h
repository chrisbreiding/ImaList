#import <UIKit/UIKit.h>
#import "ListsViewController.h"
#import "ItemsViewController.h"
#import "EditorViewController.h"
#import "OptionsView.h"

@interface MainViewController : UIViewController <ItemsDelegate, ListsDelegate, OptionsViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UILabel *listNameLabel;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIView *noConnectionView;
@property (nonatomic, weak) IBOutlet UIButton *listsButton;
@property (nonatomic, weak) IBOutlet UIButton *editListsButton;
@property (nonatomic, weak) IBOutlet UIButton *addListButton;
@property (nonatomic, weak) IBOutlet UIButton *clearCompletedButton;
@property (nonatomic, weak) IBOutlet UIButton *addItemButton;
@property (nonatomic, weak) IBOutlet UIButton *sortItemsButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *footerBottomConstraint;

- (IBAction)clearCompleted:(id)sender;
- (IBAction)addItem:(id)sender;
- (IBAction)sortItems:(id)sender;
- (IBAction)toggleLists:(id)sender;
- (IBAction)showLists:(id)sender;
- (IBAction)hideLists:(id)sender;
- (IBAction)addList:(id)sender;
- (IBAction)toggleListEditingMode:(id)sender;

@end
