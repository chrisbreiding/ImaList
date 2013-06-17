#import <Foundation/Foundation.h>

@class List;

@protocol ListListDataSource <NSObject>

- (NSInteger)listCount;
- (List *)listAtIndex:(NSInteger)index;
- (NSInteger)indexOfList:(List *)list;
- (void)deleteListAtIndex:(NSInteger)index;
- (List *)createListWithName:(NSString *)name;
- (void)commitChanges;

@end