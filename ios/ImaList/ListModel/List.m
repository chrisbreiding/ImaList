#import "List.h"

@implementation List {
    NSDictionary *items;
}

- (instancetype)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
        self._id = values[@"_id"];
        self.name = values[@"name"];
        self.ref = values[@"ref"];
        items = values[@"items"];
        [self updateImportantCount];
    }
    return self;
}

-(void)updateWithValues:(NSDictionary *)values {
    self.name = values[@"name"];
    items = values[@"items"];
    [self updateImportantCount];
}

- (BOOL)isEqualToList:(List *)list {
    return [self._id isEqualToString:list._id];
}

- (void)updateImportantCount {
    __block NSUInteger count = 0;
    [items enumerateKeysAndObjectsUsingBlock:^(NSString *_id, NSDictionary *item, BOOL *stop) {
        if ([item[@"importance"] integerValue] > 0) {
            count++;
        }
    }];
    self.importantCount = count;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<List - name:%@ _id:%@>", self.name, self._id];
}

@end
