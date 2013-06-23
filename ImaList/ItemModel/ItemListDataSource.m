#import <Firebase/Firebase.h>
#import "ItemListDataSource.h"
#import "Item.h"

@implementation ItemListDataSource {
    NSMutableArray *_items;
    Firebase *itemsRef;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        itemsRef = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com/items"];
//        [itemsRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            for (FDataSnapshot *childSnapshot in snapshot.children) {
//                [_items addObject:childSnapshot.ref];
//            }
//        }];
        
        [itemsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"item added: %@", snapshot.value[@"name"]);
            [self itemCreatedWithValues:@{
                @"_id": snapshot.name,
                @"name": snapshot.value[@"name"],
                @"isChecked": snapshot.value[@"isChecked"],
                @"ref": snapshot.ref
             }];
        }];
        
        [itemsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"item changed: %@", snapshot.value[@"name"]);
            [self itemChangedWithValues:@{
                 @"_id": snapshot.name,
                 @"name": snapshot.value[@"name"],
                 @"isChecked": snapshot.value[@"isChecked"]
             }];
        }];
        
        [itemsRef observeEventType:FEventTypeChildMoved withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"item moved: %@", snapshot.value[@"name"]);
            NSLog(@"moved: %@", snapshot);
        }];
        
        [itemsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"item removed: %@", snapshot.value[@"name"]);
            NSLog(@"removed: %@", snapshot);
            [self itemRemovedWithId:snapshot.name];
        }];
    }
    return self;
}

#pragma mark - public - info

- (NSInteger)itemCount {
    return _items.count;
}

- (Item *)itemAtIndex:(NSInteger)index {
    return [_items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(Item *)item {
    return [_items indexOfObject:item];
}

#pragma mark - public - actions

- (void)createItemWithValues:(NSDictionary *)values {
    Firebase *newItem = [itemsRef childByAutoId];
    [newItem setValue:values andPriority:@(_items.count)];
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
    [_items sortUsingComparator:^NSComparisonResult(Item *item1, Item *item2) {
        if (item1.isChecked != item2.isChecked) {
            if (item1.isChecked) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
        return NSOrderedSame;
    }];
    // sort in firebase
}

- (void)clearCompleted {
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = (Item *)obj;
        if (item.isChecked) {
            [self removeItem:item];
        }
    }];
}

#pragma mark - private

- (Item *)itemWithId:(NSString *)_id {
    __block Item *foundItem = nil;
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = (Item *)obj;
        if ([item._id isEqualToString:_id]) {
            foundItem = item;
            *stop = YES;
        }
    }];
    return foundItem;
}

- (void)itemCreatedWithValues:(NSDictionary *)values {
    Item *item = [[Item alloc] init];
    item._id = values[@"_id"];
    item.name = values[@"name"];
    item.isChecked = [values[@"isChecked"] boolValue];
    item.ref = values[@"ref"];
    [_items addObject:item];
    int index = [self indexOfItem:item];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemCreated"
                                                        object:nil
                                                      userInfo:@{ @"index": @(index) }];
}

- (void)itemChangedWithValues:(NSDictionary *)values {
    Item *item = [self itemWithId:values[@"_id"]];
    item.name = values[@"name"];
    item.isChecked = [values[@"isChecked"] boolValue];
    int index = [self indexOfItem:item];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemChanged"
                                                        object:nil
                                                      userInfo:@{ @"index": @(index) }];
}

- (void)itemRemovedWithId:(NSString *)_id {
    Item *item = [self itemWithId:_id];
    int index = [self indexOfItem:item];
    [_items removeObjectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"itemRemoved"
                                                        object:nil
                                                      userInfo:@{ @"index": @(index) }];
}

@end
