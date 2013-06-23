#import <Foundation/Foundation.h>

@class Item;
@protocol ItemListDataSourceDelegate;

@interface ItemListDataSource : NSObject

@property (nonatomic, weak) id<ItemListDataSourceDelegate> delegate;

- (NSInteger)itemCount;
- (Item *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(Item *)item;
- (void)createItemWithValues:(NSDictionary *)values;
- (void)updateItem:(Item *)item name:(NSString *)name;
- (void)updateItem:(Item *)item isChecked:(BOOL)isChecked;
- (void)removeItem:(Item *)item;
- (void)sortItems;
- (void)clearCompleted;

@end

@protocol ItemListDataSourceDelegate <NSObject>

- (void)didCreateItemAtIndex:(int)index;
- (void)didUpdateItemAtIndex:(int)index;
- (void)didRemoveItemAtIndex:(int)index;
- (void)didSortItems;

@end