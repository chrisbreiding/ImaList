#import "ListListDataSource.h"
#import "List.h"
#import "FDataSnapshot+UtilityMethods.h"
#import <Firebase/Firebase.h>

@implementation ListListDataSource {
    NSMutableArray *lists;
    BOOL initialized;
    Firebase *listsRef;
}

- (instancetype)initWithFirebaseRef:(Firebase *)ref {
    self = [super init];
    if (self) {
        lists = [NSMutableArray array];
        listsRef = ref;
        
        [listsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value == (id)[NSNull null]) {
                [self createListWithName:@"Grocery"];
            } else {
                if (!initialized) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *currentListId = [defaults stringForKey:@"currentList"];
                    List *list = currentListId ? [self listWithId:currentListId] : [self listAtIndex:0];
                    [self.delegate updateCurrentList:list];
                    initialized = YES;
                }
            }
        }];
        
        [listsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *values = [snapshot valuesOrDefaults:[self listDefaults]];
            
            [self listCreatedWithValues:@{
                 @"_id": snapshot.name,
                 @"name": values[@"name"],
                 @"items": values[@"items"],
                 @"ref": snapshot.ref
             }];
        }];
        
        [listsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *values = [snapshot valuesOrDefaults:[self listDefaults]];

            [self listChangedWithValues:@{
                 @"_id": snapshot.name,
                 @"name": values[@"name"],
                 @"items": values[@"items"]
             }];
        }];
        
        [listsRef observeEventType:FEventTypeChildMoved andPreviousSiblingNameWithBlock:^(FDataSnapshot *snapshot, NSString *prevName) {
            [self sortedListAtId:snapshot.name withPreviousId:prevName];
        }];
        
        [listsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
            [self listRemovedWithId:snapshot.name];
        }];
    }
    return self;
}

#pragma mark - public - info

- (NSInteger)listCount {
    return lists.count;
}

- (List *)listAtIndex:(NSInteger)index {
    return [lists objectAtIndex:index];
}

- (NSInteger)indexOfList:(List *)list {
    return [lists indexOfObject:list];
}

#pragma mark - public actions

- (void)storeCurrentList:(List *)list {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:list._id forKey:@"currentList"];
}

- (void)createListWithName:(NSString *)name {
    Firebase *newList = [listsRef childByAutoId];
    [newList setValue:@{ @"name": name } andPriority:@(lists.count)];
}

- (void)updateList:(List *)list name:(NSString *)name {
    [list.ref updateChildValues:@{ @"name": name }];
}

- (void)moveListFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    List *list = [self listAtIndex:fromIndex];
    [lists removeObject:list];
    [lists insertObject:list atIndex:toIndex];
    [self updatePriorities];
}

- (void)removeList:(List *)list {
    [list.ref removeValue];
}

#pragma mark - private

- (List *)listWithId:(NSString *)_id {
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"_id == %@", _id];
    return [lists filteredArrayUsingPredicate:idPredicate][0];
}

- (void)listCreatedWithValues:(NSDictionary *)values {
    List *list = [[List alloc] initWithValues:values];
    [lists addObject:list];
    [self.delegate didCreateListAtIndex:[self indexOfList:list]];
}

- (void)listChangedWithValues:(NSDictionary *)values {
    List *list = [self listWithId:values[@"_id"]];
    [list updateWithValues:values];
    [self.delegate didUpdateListAtIndex:[self indexOfList:list]];
    [self updateTotalImportantCount];
}

- (void)sortedListAtId:(NSString *)_id withPreviousId:(NSString *)previousId {
    List *list = [self listWithId:_id];
    NSUInteger toIndex = 0;
    if (previousId) {
        List *previousList = [self listWithId:previousId];
        toIndex = [self indexOfList:previousList] + 1;
        if (toIndex >= [self listCount]) toIndex = [self listCount] - 1;
    }
    [lists removeObject:list];
    [lists insertObject:list atIndex:toIndex];
    [self.delegate didSortLists];
}

- (void)updatePriorities {
    [lists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        List *list = (List *)obj;
        [list.ref setPriority:@(idx)];
    }];
}

- (void)updateTotalImportantCount {
    __block NSUInteger count = 0;
    [lists enumerateObjectsUsingBlock:^(List *list, NSUInteger idx, BOOL *stop) {
        count += list.importantCount;
    }];
    [self.delegate didUpdateTotalImportantCount:count];
}

- (void)listRemovedWithId:(NSString *)_id {
    List *list = [self listWithId:_id];
    NSUInteger index = [self indexOfList:list];
    [lists removeObjectAtIndex:index];
    [self.delegate didRemoveListAtIndex:index];
}

- (NSDictionary *)listDefaults {
    return @{
             @"name": @"list",
             @"items": @{}
             };
}

@end
