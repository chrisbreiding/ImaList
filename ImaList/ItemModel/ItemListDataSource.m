#import <Firebase/Firebase.h>
#import "ItemListDataSource.h"
#import "Item.h"

@implementation ItemListDataSource {
    NSMutableArray *items;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        items = [NSMutableArray array];
    }
    return self;
}

- (void)setItemsRef:(Firebase *)itemsRef {
    items = [NSMutableArray array];
    [_itemsRef removeAllObservers];
    _itemsRef = itemsRef;
    
    [_itemsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [self itemCreatedWithValues:@{
             @"_id": snapshot.name,
             @"name": snapshot.value[@"name"],
             @"isChecked": snapshot.value[@"isChecked"],
             @"ref": snapshot.ref
         }];
    }];
    
    [_itemsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        [self itemChangedWithValues:@{
             @"_id": snapshot.name,
             @"name": snapshot.value[@"name"],
             @"isChecked": snapshot.value[@"isChecked"]
         }];
    }];
    
    [_itemsRef observeEventType:FEventTypeChildMoved andPreviousSiblingNameWithBlock:^(FDataSnapshot *snapshot, NSString *prevName) {
        [self itemsSorted];
    }];
    
    [_itemsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        [self itemRemovedWithId:snapshot.name];
    }];
}

#pragma mark - public - info

- (NSInteger)itemCount {
    return items.count;
}

- (Item *)itemAtIndex:(NSInteger)index {
    return [items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(Item *)item {
    return [items indexOfObject:item];
}

#pragma mark - public - actions

- (void)createItemWithValues:(NSDictionary *)values {
    Firebase *newItem = [_itemsRef childByAutoId];
    [newItem setValue:values andPriority:@(items.count)];
}

- (void)updateItem:(Item *)item name:(NSString *)name {
    [item.ref updateChildValues:@{ @"name": name }];
}

- (void)updateItem:(Item *)item isChecked:(BOOL)isChecked {
    [item.ref updateChildValues:@{ @"isChecked": @(isChecked) }];
}

- (void)removeItem:(Item *)item {
    [item.ref removeValue];
}

- (void)sortItems {
    [items sortUsingComparator:^NSComparisonResult(Item *item1, Item *item2) {
        if (item1.isChecked != item2.isChecked) {
            if (item1.isChecked) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
        return NSOrderedSame;
    }];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = (Item *)obj;
        [item.ref setPriority:@(idx)];
    }];
}

- (void)clearCompleted {
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = (Item *)obj;
        if (item.isChecked) {
            [self removeItem:item];
        }
    }];
}

#pragma mark - private

- (Item *)itemWithId:(NSString *)_id {
    __block Item *foundItem = nil;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = (Item *)obj;
        if ([item._id isEqualToString:_id]) {
            foundItem = item;
            *stop = YES;
        }
    }];
    return foundItem;
}

- (void)itemCreatedWithValues:(NSDictionary *)values {
    Item *item = [[Item alloc] initWithValues:values];
    [items addObject:item];
    [self.delegate didCreateItemAtIndex:[self indexOfItem:item]];
}

- (void)itemChangedWithValues:(NSDictionary *)values {
    Item *item = [self itemWithId:values[@"_id"]];
    item.name = values[@"name"];
    item.isChecked = [values[@"isChecked"] boolValue];
    [self.delegate didUpdateItemAtIndex:[self indexOfItem:item]];
}

- (void)itemsSorted {
    [self.delegate didSortItems];
}

- (void)itemRemovedWithId:(NSString *)_id {
    Item *item = [self itemWithId:_id];
    int index = [self indexOfItem:item];
    [items removeObjectAtIndex:index];
    [self.delegate didRemoveItemAtIndex:index];
}

@end
