#import "FDataSnapshot+UtilityMethods.h"

@implementation FDataSnapshot (UtilityMethods)

- (NSDictionary *)valuesOrDefaults:(NSDictionary *)defaults {
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    for (NSString *key in defaults) {
        id value = self.value[key];
        if (!value) {
            value = defaults[key];
        }
        [values setObject:value forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:values];
}

@end
