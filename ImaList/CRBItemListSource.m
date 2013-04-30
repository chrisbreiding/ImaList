//
//  CRBItemListSource.m
//  ImaList
//
//  Created by CB on 04/27/13.
//  Copyright (c) 2013 CB. All rights reserved.
//

#import "CRBItemListSource.h"
#import "CRBItem.h"

@interface CRBItemListSource ()

@property(nonatomic, strong) NSMutableArray *items;

@end

@implementation CRBItemListSource

- (NSMutableArray *)items {
    NSArray *fixtureItems = @[
        @{ @"name": @"eggs", @"isChecked": @(NO) },
        @{ @"name": @"bread", @"isChecked": @(YES) },
        @{ @"name": @"milk", @"isChecked": @(NO) },
        @{ @"name": @"potato chips", @"isChecked": @(YES) },
        @{ @"name": @"butter", @"isChecked": @(YES) },
        @{ @"name": @"orange juice", @"isChecked": @(NO) },
        @{ @"name": @"turkey", @"isChecked": @(NO) },
        @{ @"name": @"bacon", @"isChecked": @(YES) },
        @{ @"name": @"tomatoes", @"isChecked": @(NO) }
    ];
    
    if (!_items) {
        self.items = [NSMutableArray array];
        for (NSDictionary *item in fixtureItems) {
            CRBItem *newItem = [[CRBItem alloc] init];
            newItem.name = item[@"name"];
            newItem.isChecked = item[@"isChecked"];
            [self.items addObject:newItem];
        }
    }
    [self sortItems];
    return _items;
}

- (NSInteger)itemCount {
    return self.items.count;
}

- (CRBItem *)itemAtIndex:(NSInteger)index {
    return [self.items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(CRBItem *)item {
    return [self.items indexOfObject:item];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [self.items removeObjectAtIndex:index];
}

- (CRBItem *)createCountDown {
    CRBItem *newItem = [[CRBItem alloc] init];
    [self.items addObject:newItem];
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
    
    self.items = [NSMutableArray arrayWithArray:sortedItems];
}

- (void)itemsChanged {
    [self sortItems];
    // persist data
}

@end
