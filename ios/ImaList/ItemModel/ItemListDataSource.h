#import <Foundation/Foundation.h>

@class Item;
@class Firebase;
@protocol ItemListDataSourceDelegate;

@interface ItemListDataSource : NSObject

@property (nonatomic, weak) id<ItemListDataSourceDelegate> delegate;
@property (nonatomic, strong) Firebase *itemsRef;

- (NSInteger)itemCount;
- (Item *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(Item *)item;
- (void)createItemWithValues:(NSDictionary *)values;
- (void)updateItem:(Item *)item name:(NSString *)name;
- (void)updateItem:(Item *)item isChecked:(BOOL)isChecked;
- (void)updateItem:(Item *)item importance:(NSUInteger)importance;
- (void)removeItem:(Item *)item;
- (void)sortItems;
- (void)clearCompleted;

@end

@protocol ItemListDataSourceDelegate <NSObject>

- (void)didLoadItemsNonZero:(BOOL)nonZero;
- (void)didCreateItemAtIndex:(NSUInteger)index;
- (void)didUpdateItemAtIndex:(NSUInteger)index;
- (void)didRemoveItemAtIndex:(NSUInteger)index;
- (void)didSortItems;

@end