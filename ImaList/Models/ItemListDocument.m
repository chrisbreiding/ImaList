#import "ItemListDocument.h"
#import "Item.h"

@implementation ItemListDocument {
    NSMutableArray *_items;
}

- (id)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        id value = nil;
        NSError *error = nil;
        if(![url getResourceValue:&value
                           forKey:NSURLAttributeModificationDateKey
                            error:&error]) {
            [self saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if(!success) {
                  NSLog(@"Failed to create file");
              }
          }];
        }
    }
    return self;
}

//- (instancetype)init {
//    NSArray *fixtureItems = @[
//                              @{ @"name": @"eggs",         @"isChecked": @(NO)  },
//                              @{ @"name": @"bread",        @"isChecked": @(YES) },
//                              @{ @"name": @"milk",         @"isChecked": @(NO)  },
//                              @{ @"name": @"potato chips", @"isChecked": @(YES) },
//                              @{ @"name": @"butter",       @"isChecked": @(YES) },
//                              @{ @"name": @"orange juice", @"isChecked": @(NO)  },
//                              @{ @"name": @"turkey",       @"isChecked": @(NO)  },
//                              @{ @"name": @"bacon",        @"isChecked": @(YES) },
//                              @{ @"name": @"mustard",      @"isChecked": @(YES) },
//                              @{ @"name": @"cheese",       @"isChecked": @(NO)  },
//                              @{ @"name": @"jelly",        @"isChecked": @(YES) },
//                              @{ @"name": @"strawberries", @"isChecked": @(NO)  },
//                              @{ @"name": @"yogurt",       @"isChecked": @(NO)  },
//                              @{ @"name": @"carrots",      @"isChecked": @(NO)  },
//                              @{ @"name": @"tomatoes",     @"isChecked": @(NO)  }
//                              ];
//    
//    self = [super init];
//    if (self) {
//        if (!_items) {
//            _items = [NSMutableArray array];
//            for (NSDictionary *item in fixtureItems) {
//                [self createCountDownWithName:item[@"name"] checked:item[@"isChecked"]];
//            }
//        }
//        
//        [self sortItems];
//    }
//    return self;
//}

#pragma mark - persistence

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    BOOL success = NO;
    if([contents isKindOfClass:[NSData class]] && [contents length] > 0) {
        NSData *data = (NSData *)contents;
        _items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!_items) {
            _items = [NSMutableArray array];
        }
        success = YES;
    }
    return success;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    return [NSKeyedArchiver archivedDataWithRootObject:_items];
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    if([[error domain] isEqualToString:NSCocoaErrorDomain] &&
       [error code] == NSFileReadNoSuchFileError) {
        [self saveToURL:[self fileURL]
       forSaveOperation:UIDocumentSaveForCreating
      completionHandler:^(BOOL success) {
          // ignore it here, we just wanted to make sure the document is created
          NSLog(@"handled open error with a new doc");
      }];
    } else {
        // if it's not a NSFileReadNoSuchFileError just call super
        [super handleError:error userInteractionPermitted:userInteractionPermitted];
    }
}

#pragma mark - data source delegate

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
    [self commitChanges];
}

- (Item *)createCountDownWithName:(NSString *)name checked:(NSNumber *)isChecked {
    Item *newItem = [[Item alloc] init];
    newItem.name = name;
    newItem.isChecked = isChecked;
    [_items addObject:newItem];
    [self commitChanges];
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
    [self commitChanges];
}

- (void)clear {
    _items = [NSMutableArray array];
    [self commitChanges];
}

- (void)clearCompleted {
    [_items filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id item, NSDictionary *bindings) {
        return ![[item isChecked] boolValue];
    }]];
    [self commitChanges];
}

- (void)commitChanges {
    [self updateChangeCount:UIDocumentChangeDone];
}

@end
