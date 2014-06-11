#import "Item.h"

@implementation Item

- (instancetype)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
        __id = values[@"_id"];
        _name = values[@"name"];
        _isChecked = [values[@"isChecked"] boolValue];
        _importance = [values[@"importance"] integerValue];
        _ref = values[@"ref"];
    }
    return self;
}

- (void)updateWithValues:(NSDictionary *)values {
    self.name = values[@"name"];
    self.isChecked = [values[@"isChecked"] boolValue];
    self.importance = [values[@"importance"] integerValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Item - name:%@ _id:%@ isChecked:%@ importance:%d>", self.name, self._id, self.isChecked ? @"yes" : @"no", self.importance];
}

@end
