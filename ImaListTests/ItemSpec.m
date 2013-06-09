#import "Kiwi.h"
#import "Item.h"

SPEC_BEGIN(ItemSpec)

describe(@"Item Model", ^{
    __block Item *item;
    
    beforeEach(^{
        item = [[Item alloc] init];
    });
    
    it(@"is not nil", ^{
        [[item shouldNot] beNil];
    });
});

SPEC_END
