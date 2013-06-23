#import <Foundation/Foundation.h>

@class List;

@interface ListListDataSource : NSObject

- (NSInteger)listCount;
- (List *)listAtIndex:(NSInteger)index;
- (NSInteger)indexOfList:(List *)list;
- (void)removeListAtIndex:(NSInteger)index;
- (List *)createListWithName:(NSString *)name;

@end