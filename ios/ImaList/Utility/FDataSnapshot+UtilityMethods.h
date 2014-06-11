#import <Firebase/Firebase.h>

@interface FDataSnapshot (UtilityMethods)

- (NSDictionary *)valuesOrDefaults:(NSDictionary *)defaults;

@end
