#import "ItemTableCell.h"
#import "Item.h"

static UIImage *cellBackgroundImage;

__attribute__((constructor))
static void initialize_cache() {
    cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 0)];
}

__attribute__((destructor))
static void destroy_cache() {
    cellBackgroundImage = nil;
}

@implementation ItemTableCell {
    BOOL deleteButtonShown;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self style];
    [self addSwipeGestures];
}

-(void)configureCellWithItem:(Item *)item {
    _item = item;
    [self addAttributes];
    if (deleteButtonShown) {
        [self hideDeleteButtonAnimated:NO];
    }
}

- (void)style {
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    cellBackgroundView.image = cellBackgroundImage;
    self.backgroundView = cellBackgroundView;
}

- (void)addAttributes {
    self.itemNameLabel.text = _item.name;
    
    NSString *checkImageName = @"icon-unchecked.png";
    if (_item.isChecked) {
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
    [self.delegate didUpdateItem:_item isChecked:!_item.isChecked];
}

#pragma mark - swipes

- (void)addSwipeGestures {
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(didSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(didSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
}

- (void)didSwipeRight:(UIGestureRecognizer *)sender {
    [self hideDeleteButtonAnimated:YES];
}

- (void)didSwipeLeft:(UIGestureRecognizer *)sender {
    [self showDeleteButtonAnimated:YES];
}

#pragma mark - deletion

- (void)showDeleteButtonAnimated:(BOOL)animated {
    deleteButtonShown = YES;
    self.deleteButton.hidden = NO;
    self.deleteButtonTrailingConstraint.constant = 0;
    [self relayoutAnimate:animated completion:nil];
}

- (void)hideDeleteButtonAnimated:(BOOL)animated {
    deleteButtonShown = NO;
    self.deleteButtonTrailingConstraint.constant = -60;
    [self relayoutAnimate:animated completion:^{
        self.deleteButton.hidden = YES;
    }];
}

- (void)relayoutAnimate:(BOOL)animated completion:(void (^)())completion {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    } else {
        [self layoutIfNeeded];
    }
}

- (IBAction)didTapDelete:(id)sender {
    [self.delegate didDeleteItem:_item];
}

@end
