#import "List.h"

@implementation List

- (instancetype)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
        self._id = values[@"_id"];
        self.name = values[@"name"];
        self.ref = values[@"ref"];
    }
    return self;
}

- (BOOL)isEqualToList:(List *)list {
    return [self._id isEqualToString:list._id];
}

@end
