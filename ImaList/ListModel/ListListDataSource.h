#import <Foundation/Foundation.h>

@class List;
@class Firebase;
@protocol ListListDataSourceDelegate;

@interface ListListDataSource : NSObject

@property (nonatomic, weak) id<ListListDataSourceDelegate> delegate;

- (instancetype)initWithFirebaseRef:(Firebase *)ref;

- (NSInteger)listCount;
- (List *)listAtIndex:(NSInteger)index;
- (NSInteger)indexOfList:(List *)list;
- (void)storeCurrentList:(List *)list;
- (void)createListWithName:(NSString *)name;
- (void)updateList:(List *)list name:(NSString *)name;
- (void)moveListFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)index;
- (void)removeList:(List *)list;

@end

@protocol ListListDataSourceDelegate <NSObject>

- (void)updateCurrentList:(List *)list;
- (void)didCreateListAtIndex:(NSUInteger)index;
- (void)didUpdateListAtIndex:(NSUInteger)index;
- (void)didSortLists;
- (void)didRemoveListAtIndex:(NSUInteger)index;

@end