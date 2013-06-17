#import <Foundation/Foundation.h>

@class Item;

@protocol ItemListDataSource <NSObject>

- (NSInteger)itemCount;
- (Item *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(Item *)item;
- (void)deleteItemAtIndex:(NSInteger)index;
- (Item *)createItemWithName:(NSString *)name checked:(NSNumber *)isChecked;
- (void)sortItems;
- (void)clear;
- (void)clearCompleted;
- (void)commitChanges;

@end