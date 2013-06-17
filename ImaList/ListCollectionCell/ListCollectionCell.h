#import <UIKit/UIKit.h>

@class List;

@interface ListCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *listNameLabel;

- (void)configureCellWithList:(List *)list;

@end
