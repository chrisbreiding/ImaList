#import "ItemListSource.h"
#import "Item.h"

@implementation ItemListSource {
    NSMutableArray *_items;
}

- (ItemListSource *)init {
    NSArray *fixtureItems = @[
        @{ @"name": @"eggs",         @"isChecked": @(NO)  },
        @{ @"name": @"bread",        @"isChecked": @(YES) },
        @{ @"name": @"milk",         @"isChecked": @(NO)  },
        @{ @"name": @"potato chips", @"isChecked": @(YES) },
        @{ @"name": @"butter",       @"isChecked": @(YES) },
        @{ @"name": @"orange juice", @"isChecked": @(NO)  },
        @{ @"name": @"turkey",       @"isChecked": @(NO)  },
        @{ @"name": @"bacon",        @"isChecked": @(YES) },
        @{ @"name": @"mustard",      @"isChecked": @(YES) },
        @{ @"name": @"cheese",       @"isChecked": @(NO)  },
        @{ @"name": @"jelly",        @"isChecked": @(YES) },
        @{ @"name": @"strawberries", @"isChecked": @(NO)  },
        @{ @"name": @"yogurt",       @"isChecked": @(NO)  },
        @{ @"name": @"carrots",      @"isChecked": @(NO)  },
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

- (Item *)itemAtIndex:(NSInteger)index {
    return [_items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(Item *)item {
    return [_items indexOfObject:item];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [_items removeObjectAtIndex:index];
}

- (Item *)createCountDownWithName:(NSString *)name checked:(NSNumber *)isChecked {
    Item *newItem = [[Item alloc] init];
    newItem.name = name;
    newItem.isChecked = isChecked;
    [_items addObject:newItem];
    return newItem;
}

- (void)sortItems {
    [_items sortUsingComparator:^NSComparisonResult(Item *item1, Item *item2) {
        if ([item1.isChecked boolValue] != [item2.isChecked boolValue]) {
            if ([item1.isChecked boolValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }
        return NSOrderedSame;
    }];
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
