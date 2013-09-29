#import "ItemTableCell.h"
#import "Item.h"

static UIImage *cellBackgroundImage;

__attribute__((constructor))
static void initialize_cache() {
    cellBackgroundImage = [[UIImage imageNamed:@"item-cell.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 1, 10)];
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
    UIColor *labelColor = [UIColor blackColor];
    if (_item.isChecked) {
        checkImageName = @"icon-checked.png";
        labelColor = [UIColor lightGrayColor];
        self.importantButton.hidden = YES;
    } else {
        NSString *importantImageName = @"icon-unimportant.png";
        if (_item.importance > 0) {
            importantImageName = @"icon-important.png";
        }
        [self.importantButton setImage:[UIImage imageNamed:importantImageName] forState:UIControlStateNormal];
        self.importantButton.hidden = NO;
    }
    [self.checkboxButton setImage:[UIImage imageNamed:checkImageName] forState:UIControlStateNormal];
    self.itemNameLabel.textColor = labelColor;
}

- (IBAction)didTapCheckmark:(id)sender {
    [self.delegate didUpdateItem:_item isChecked:!_item.isChecked];
}

- (IBAction)didTapImportant:(id)sender {
    NSUInteger importance = _item.importance;
    importance++;
    if (importance > MAX_ITEM_IMPORTANCE) {
        importance = 0;
    }
    [self.delegate didUpdateItem:_item importance:importance];
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
    self.deleteButtonTrailingConstraint.constant = -50;
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
