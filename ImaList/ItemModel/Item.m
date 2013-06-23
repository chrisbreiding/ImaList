#import "Item.h"

@implementation Item

- (instancetype)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
        self._id = values[@"_id"];
        self.name = values[@"name"];
        self.isChecked = [values[@"isChecked"] boolValue];
        self.ref = values[@"ref"];
    }
    return self;
}

@end
