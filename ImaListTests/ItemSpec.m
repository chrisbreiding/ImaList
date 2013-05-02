#import "Kiwi.h"
#import "CRBItem.h"

SPEC_BEGIN(ItemSpec)

describe(@"Item Model", ^{
    __block CRBItem *item;
    
    beforeEach(^{
        item = [[CRBItem alloc] init];
    });
    
    it(@"is not nil", ^{
        [[item shouldNot] beNil];
    });
});

SPEC_END
