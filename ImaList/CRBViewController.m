//
//  CRBViewController.m
//

#import "CRBViewController.h"
#import "CRBItemListSource.h"
#import "CRBItem.h"

//@interface CRBViewController ()
//
//- (void)styleView;
//- (void)styleNavBar;
//- (void)styleCell:(UITableViewCell *)cell;
//- (void)giveAttributesToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//
//@end
//
@implementation CRBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleView];
    [self styleNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self styleCell:cell];
    [self giveAttributesToCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)styleView {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)styleNavBar {
    self.navBarImageView.image = [[UIImage imageNamed:@"nav-bar.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0, 1.0, 0)];
    [self.listsButton setBackgroundImage:[[UIImage imageNamed:@"nav-bar-button.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)]
                                forState:UIControlStateNormal];
    [self.clearCompletedButton setBackgroundImage:[[UIImage imageNamed:@"nav-bar-button.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)]
                                forState:UIControlStateNormal];
}

- (void)styleCell:(UITableViewCell *)cell {
    UIImage *cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 44.0, 1.0, 0)];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithFrame:cell.frame];
    cellBackgroundView.image = cellBackgroundImage;
    cell.backgroundView = cellBackgroundView;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
}

- (void)giveAttributesToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CRBItem *item = [self.dataSource itemAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    
    NSString *checkImageName = @"unchecked.png";
    if ([item.isChecked boolValue]) {
        checkImageName = @"checked.png";
    }
    
    cell.imageView.image = [UIImage imageNamed:checkImageName];
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.tag = indexPath.row;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkmarkTapped:)];
    [cell.imageView setGestureRecognizers:@[]];
    [cell.imageView addGestureRecognizer:gestureRecognizer];
}

- (void)checkmarkTapped:(id)gesture {
    CRBItem *item = [self.dataSource itemAtIndex:[[gesture view] tag]];
    BOOL isChecked = [item.isChecked boolValue];
    
    item.isChecked = @(!isChecked);

    [self.dataSource itemsChanged];
    [self.tableView reloadData];
}

@end
