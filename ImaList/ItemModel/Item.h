#import <Foundation/Foundation.h>

static const NSUInteger MAX_ITEM_IMPORTANCE = 1;

@class Firebase;

@interface Item : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isChecked;
@property (nonatomic) NSUInteger importance;
@property (nonatomic, strong) Firebase *ref;

- (instancetype)initWithValues:(NSDictionary *)values;

@end
