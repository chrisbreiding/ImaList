#import <Firebase/Firebase.h>
#import "ListListDataSource.h"
#import "List.h"

@implementation ListListDataSource {
    NSMutableArray *lists;
}

- (id)init {
    self = [super init];
    if (self) {
        lists = [NSMutableArray array];
//        Firebase* listsRef = [[Firebase alloc] initWithUrl:@"https://imalist.firebaseio.com/lists"];
//        [listsRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            NSLog(@"%@", snapshot.value);
//        }];
    }
    return self;
}

- (NSInteger)listCount {
    return lists.count;
}

- (List *)listAtIndex:(NSInteger)index {
    return [lists objectAtIndex:index];
}

- (NSInteger)indexOfList:(List *)list {
    return [lists indexOfObject:list];
}

- (void)removeListAtIndex:(NSInteger)index {
    [lists removeObjectAtIndex:index];
    // delete from firebase
}

- (List *)createListWithName:(NSString *)name {
    List *newList = [[List alloc] init];
    newList.name = name;
    newList.items = @[];
    [lists addObject:newList];
    // add to firebase
    return newList;
}

@end
