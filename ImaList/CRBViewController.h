#import <UIKit/UIKit.h>
#import "CRBItemListDataSource.h"

@interface CRBViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id<CRBItemListDataSource> dataSource;

@property (nonatomic, weak) IBOutlet UIView *navBarView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UIButton *listsButton;
@property (nonatomic, weak) IBOutlet UIButton *clearCompletedButton;
@property (nonatomic, weak) IBOutlet UIButton *addItemButton;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction) clearCompleted:(id)sender;
- (IBAction) addItem:(id)sender;
- (void) checkmarkTapped:(id)gesture;

@end
