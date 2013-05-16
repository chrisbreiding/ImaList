//
//  CRBViewController.h
//

#import <UIKit/UIKit.h>
#import "CRBItemListDataSource.h"

@interface CRBViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<CRBItemListDataSource> dataSource;

@property (nonatomic, strong) IBOutlet UIImageView *navBarImageView;
@property (nonatomic, strong) IBOutlet UIButton *listsButton;
@property (nonatomic, strong) IBOutlet UIButton *clearCompletedButton;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction) didPressClearCompleted:(id)sender;
- (void) checkmarkTapped:(id)gesture;

@end
