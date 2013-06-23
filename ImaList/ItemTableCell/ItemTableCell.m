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
    BOOL deleteButtonShown;
    NSLayoutConstraint *deleteButtonShownConstraint;
    NSLayoutConstraint *deleteButtonHiddenConstraint;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self style];
    [self addSwipeGestures];
    deleteButtonHiddenConstraint = self.deleteButtonTrailingConstraint;
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
    [self showDeleteButtonAnimated:YES];
}

- (void)didSwipeLeft:(UIGestureRecognizer *)sender {
    [self hideDeleteButtonAnimated:YES];
}

#pragma mark - deletion

- (void)showDeleteButtonAnimated:(BOOL)animated {
    deleteButtonShown = YES;
    if (!deleteButtonShownConstraint) {
        UIButton *deleteButton = self.deleteButton;
        NSDictionary *views = NSDictionaryOfVariableBindings(deleteButton);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[deleteButton]-0-|"
                                                                       options:NSLayoutFormatAlignAllBaseline
                                                                       metrics:nil
                                                                         views:views];
        deleteButtonShownConstraint = constraints[0];
    }
    [self removeConstraint:deleteButtonHiddenConstraint];
    [self addConstraint:deleteButtonShownConstraint];
    [self relayoutAnimate:animated];
}

- (void)hideDeleteButtonAnimated:(BOOL)animated {
    deleteButtonShown = NO;
    [self removeConstraint:deleteButtonShownConstraint];
    [self addConstraint:deleteButtonHiddenConstraint];
    [self relayoutAnimate:animated];
}

- (void)relayoutAnimate:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        [self layoutIfNeeded];
    }
}

- (IBAction)didTapDelete:(id)sender {
    [self.delegate didDeleteItem:_item];
}

@end
