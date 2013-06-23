#import <Foundation/Foundation.h>

@class Firebase;

@interface Item : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isChecked;
@property (nonatomic, strong) Firebase *ref;

- (instancetype)initWithValues:(NSDictionary *)values;

@end
