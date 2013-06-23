#import <Foundation/Foundation.h>

@class Item;

@interface ItemListDataSource : NSObject

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