#import "ListCollectionCell.h"
#import "List.h"

@implementation ListCollectionCell

-(void)awakeFromNib {
    [super awakeFromNib];
    [self style];
}

- (void)configureCellWithList:(List *)list {
    self.listNameLabel.text = list.name;
}

- (void)style {
    
}

@end
