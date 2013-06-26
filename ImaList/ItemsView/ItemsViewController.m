#import "ItemsViewController.h"
#import "ItemListDataSource.h"
#import "Item.h"

@implementation ItemsViewController {
    Item *itemBeingEdited;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        ItemListDataSource *dataSource = [[ItemListDataSource alloc] init];
        _dataSource = dataSource;
        dataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:@"ItemTableCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ItemTableCell"];
    
    self.noItemsTextView.text = @"No Items Here!\n\nTap [+] to add items.";
}

- (void)updateItemsRef:(Firebase *)itemsRef {
    self.dataSource.itemsRef = itemsRef;
    [self.tableView reloadData];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ItemTableCell";
    ItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWithItem:[self.dataSource itemAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableCell *cell = (ItemTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    itemBeingEdited = cell.item;
    [self.delegate editItemName:cell.item.name];
}

#pragma mark - item list data source delegate

- (void)didLoadItemsNonZero:(BOOL)nonZero {
    self.noItemsTextView.hidden = nonZero;
}

- (void)didCreateItemAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationTop];
}

- (void)didUpdateItemAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationMiddle];
    
}

- (void)didRemoveItemAtIndex:(int)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                      withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)didSortItems {
    [self.tableView reloadData];
}

#pragma mark - item cell delegate

- (void)didUpdateItem:(Item *)item isChecked:(BOOL)isChecked {
    [self.dataSource updateItem:item isChecked:isChecked];
}

- (void)didDeleteItem:(Item *)item {
    [self.dataSource removeItem:item];
}

#pragma mark - edit mode

- (void)didFinishEditingMultiple:(NSArray *)itemNames {
    for (NSString *itemName in itemNames) {
        NSString *trimmedName = [itemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![trimmedName isEqualToString:@""]) {
            [self.dataSource createItemWithValues:@{ @"name": itemName, @"isChecked": @(NO) }];
        }
    }
}

- (void)didFinishEditingSingle:(NSString *)name {
    [self.dataSource updateItem:itemBeingEdited name:name];
}

#pragma mark - user actions

- (void)clearCompleted {
    [self.dataSource clearCompleted];
}

- (void)sortItems {
    [self.dataSource sortItems];
}

@end
