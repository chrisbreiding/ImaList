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

- (NSString *)description {
    return [NSString stringWithFormat:@"<Item - name:%@ _id:%@ isChecked:%@>", self.name, self._id, self.isChecked ? @"yes" : @"no"];
}

@end
