#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell

- (void)configureCellWithList:(List *)list {
    self.listNameLabel.text = list.name;
}

@end
