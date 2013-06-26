#import <Foundation/Foundation.h>

@class Firebase;

@interface List : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Firebase *ref;

- (instancetype)initWithValues:(NSDictionary *)values;
- (BOOL)isEqualToList:(List *)list;

@end
