#import "Kiwi.h"
#import "ItemListSource.h"
#import "Item.h"

SPEC_BEGIN(ItemListSpec)

describe(@"Item List", ^{
    __block ItemListSource *dataSource;
    
    beforeEach(^{
        dataSource = [[ItemListSource alloc] init];
    });
    
    describe(@"on initialization", ^{
        it(@"is not nil", ^{
            [[dataSource shouldNot] beNil];
        });

        it(@"populates list with items", ^{
            [[theValue([dataSource itemCount]) shouldNot] beZero];
        });
    });
    
    describe(@"creating an item", ^{
        __block Item *item;
        
        beforeEach(^{
            item = [dataSource createCountDownWithName:@"beef" checked:@(NO)];
        });
        
        it(@"is adds the item to the end of the list", ^{
            [[[dataSource itemAtIndex:[dataSource itemCount] - 1] should] equal:item];
        });
    });
    
    describe(@"after creating 3 items", ^{
        __block Item *item1;
        __block Item *item2;
        __block Item *item3;
        
        beforeEach(^{
            [dataSource clear];
            item1 = [dataSource createCountDownWithName:@"Eggs" checked:@(YES)];
            item2 = [dataSource createCountDownWithName:@"Bread" checked:@(NO)];
            item3 = [dataSource createCountDownWithName:@"Cheese" checked:@(NO)];
        });
        
        it(@"has a count of 3", ^{
            [[theValue([dataSource itemCount]) should] equal:theValue(3)];
        });
        
        it(@"has item2 at index 1", ^{
            [[[dataSource itemAtIndex:1] should] equal:item2];
        });
        
        it(@"returns index 2 for item3", ^{
            [[theValue([dataSource indexOfItem:item3]) should] equal:theValue(2)];
        });
        
        describe(@"deleting an item", ^{
            beforeEach(^{
                [dataSource deleteItemAtIndex:1];
            });
            
            it(@"has a count of 2", ^{
                [[theValue([dataSource itemCount]) should] equal:theValue(2)];
            });
            
            it(@"has item3 at index 1", ^{
                [[[dataSource itemAtIndex:1] should] equal:item3];
            });
        });

        describe(@"sorting the list", ^{
            beforeEach(^{
                [dataSource sortItems];
            });
            
            it(@"puts checked items after unchecked items", ^{
                [[[dataSource itemAtIndex:2] should] equal:item1];
            });
        });

        describe(@"clearing", ^{
            it(@"has a count of zero after clearing all", ^{
                [dataSource clear];
                [[theValue([dataSource itemCount]) should] beZero];
            });
            
            it(@"has a count of 2 after clearing completed", ^{
                [dataSource clearCompleted];
                [[theValue([dataSource itemCount]) should] equal:@2];
            });
        });
    });
    
});

SPEC_END
