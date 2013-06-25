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
- (void)createListWithName:(NSString *)name;
- (void)updateList:(List *)list name:(NSString *)name;
- (void)removeList:(List *)list;

@end

@protocol ListListDataSourceDelegate <NSObject>

- (void)didCreateListAtIndex:(int)index;
- (void)didUpdateListAtIndex:(int)index;
- (void)didRemoveListAtIndex:(int)index;

@end