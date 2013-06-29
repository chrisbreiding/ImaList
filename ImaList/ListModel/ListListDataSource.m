#import <Firebase/Firebase.h>
#import "ListListDataSource.h"
#import "List.h"

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
            [self listCreatedWithValues:@{
                 @"_id": snapshot.name,
                 @"name": snapshot.value[@"name"],
                 @"ref": snapshot.ref
             }];
        }];
        
        [listsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
            [self listChangedWithValues:@{
                 @"_id": snapshot.name,
                 @"name": snapshot.value[@"name"]
             }];
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

- (void)removeList:(List *)list {
    [list.ref removeValue];
}

#pragma mark = private

- (List *)listWithId:(NSString *)_id {
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"id == %@", _id];
    return [lists filteredArrayUsingPredicate:idPredicate][0];
}

- (void)listCreatedWithValues:(NSDictionary *)values {
    List *list = [[List alloc] initWithValues:values];
    [lists addObject:list];
    [self.delegate didCreateListAtIndex:[self indexOfList:list]];
}

- (void)listChangedWithValues:(NSDictionary *)values {
    List *list = [self listWithId:values[@"_id"]];
    list.name = values[@"name"];
    [self.delegate didUpdateListAtIndex:[self indexOfList:list]];
}

- (void)listRemovedWithId:(NSString *)_id {
    List *list = [self listWithId:_id];
    int index = [self indexOfList:list];
    [lists removeObjectAtIndex:index];
    [self.delegate didRemoveListAtIndex:index];
}

@end
