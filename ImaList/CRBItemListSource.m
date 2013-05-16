#import "CRBItemListSource.h"
#import "CRBItem.h"

@implementation CRBItemListSource {
    NSMutableArray *_items;
}

- (CRBItemListSource *)init {
    NSArray *fixtureItems = @[
        @{ @"name": @"eggs",         @"isChecked": @(NO)  },
        @{ @"name": @"bread",        @"isChecked": @(YES) },
        @{ @"name": @"milk",         @"isChecked": @(NO)  },
        @{ @"name": @"potato chips", @"isChecked": @(YES) },
        @{ @"name": @"butter",       @"isChecked": @(YES) },
        @{ @"name": @"orange juice", @"isChecked": @(NO)  },
        @{ @"name": @"turkey",       @"isChecked": @(NO)  },
        @{ @"name": @"bacon",        @"isChecked": @(YES) },
        @{ @"name": @"tomatoes",     @"isChecked": @(NO)  }
    ];
    
    self = [super init];
    if (self) {
        if (!_items) {
            _items = [NSMutableArray array];
            for (NSDictionary *item in fixtureItems) {
                [self createCountDownWithName:item[@"name"] checked:item[@"isChecked"]];
            }
        }

        [self sortItems];
    }
    return self;
}

- (NSInteger)itemCount {
    return _items.count;
}

- (CRBItem *)itemAtIndex:(NSInteger)index {
    return [_items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(CRBItem *)item {
    return [_items indexOfObject:item];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [_items removeObjectAtIndex:index];
}

- (CRBItem *)createCountDownWithName:(NSString *)name checked:(NSNumber *)isChecked {
    CRBItem *newItem = [[CRBItem alloc] init];
    newItem.name = name;
    newItem.isChecked = isChecked;
    [_items addObject:newItem];
    return newItem;
}

- (void)sortItems {
    NSArray *sortedItems = [_items sortedArrayUsingComparator:^NSComparisonResult(CRBItem *item1, CRBItem *item2) {

        if ([item1.isChecked boolValue] != [item2.isChecked boolValue]) {
            if ([item1.isChecked boolValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
        
        return NSOrderedSame;
    }];
    
    _items = [NSMutableArray arrayWithArray:sortedItems];
}

- (void)itemsChanged {
    [self sortItems];
    // persist data
}

- (void)clear {
    _items = [NSMutableArray array];
}

- (void)clearCompleted {
    [_items filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id item, NSDictionary *bindings) {
        return ![[item isChecked] boolValue];
    }]];
}

@end
