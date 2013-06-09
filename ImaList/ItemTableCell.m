#import "ItemTableCell.h"
#import "Item.h"

static UIImage *cellBackgroundImage;

__attribute__((constructor))
static void initialize_cache() {
    cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 61, 1, 0)];
}

__attribute__((destructor))
static void destroy_cache() {
    cellBackgroundImage = nil;
}

@implementation ItemTableCell {
    Item *_item;
    int _index;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self style];
}

-(void)configureCellWithItem:(Item *)item index:(int)index {
    _item = item;
    _index = index;
    [self addAttributes];
}

- (void)style {
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    cellBackgroundView.image = cellBackgroundImage;
    self.backgroundView = cellBackgroundView;
}

- (void)addAttributes {
    self.itemNameLabel.text = _item.name;
    
    NSString *checkImageName = @"icon-unchecked.png";
    if ([_item.isChecked boolValue]) {
        checkImageName = @"icon-checked.png";
        self.itemNameLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.itemNameLabel.textColor = [UIColor blackColor];
    }
    
    self.imageView.image = [UIImage imageNamed:checkImageName];
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkmarkTapped:)];
    [self.imageView setGestureRecognizers:@[gestureRecognizer]];
}

- (void)checkmarkTapped:(id)gesture {
    BOOL isChecked = [_item.isChecked boolValue];
    _item.isChecked = @(!isChecked);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadItemRow"
                                                        object:self
                                                      userInfo:@{ @"item": _item }];
}

@end
