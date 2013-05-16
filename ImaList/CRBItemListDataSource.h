//
//  CRBItemListDataSource.h
//

#import <Foundation/Foundation.h>

@class CRBItem;

@protocol CRBItemListDataSource <NSObject>

- (NSInteger)itemCount;
- (CRBItem *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(CRBItem *)item;
- (void)deleteItemAtIndex:(NSInteger)index;
- (CRBItem *)createCountDownWithName:(NSString *)name checked:(NSNumber *)isChecked;
- (void)sortItems;
- (void)itemsChanged;
- (void)clear;

@end