#import "OptionsView.h"

static CGFloat subViewHeight = 50;

@interface OptionsView ()

@property (nonatomic, weak) id<OptionsViewDelegate>delegate;

@end

@implementation OptionsView {
    CGFloat backgroundHeight;
    CGFloat width;
    CGFloat height;
    UIView *background;
    UILabel *titleLabel;
    UIButton *primaryButton;
    UIButton *cancelButton;
}

#pragma mark - public

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<OptionsViewDelegate>)delegate
           primaryButtonTitle:(NSString *)primaryButtonTitle
            cancelButtonTitle:(NSString *)cancelButtonTitle {
    self = [super init];
    if (self) {
        NSParameterAssert(delegate);
        NSParameterAssert(cancelButtonTitle);
        
        backgroundHeight = 10;
        _delegate = delegate;
        [self addBackground];
        if (title) [self addTitle:title];
        if (primaryButtonTitle) [self addPrimaryButton:primaryButtonTitle];
        if (cancelButtonTitle) [self addCancelButton:cancelButtonTitle];
        [self style];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    CGFloat subViewY = 10;
    width = view.bounds.size.width;
    height = view.bounds.size.height;
    self.frame = view.bounds;
    background.frame = CGRectMake(0, height, width, backgroundHeight);
    if (titleLabel) {
        titleLabel.frame = CGRectMake(0, subViewY, width, subViewHeight);
        subViewY += subViewHeight + 10;
    }
    if (primaryButton) {
        primaryButton.frame = CGRectMake(10, subViewY, width - 20, subViewHeight);
        subViewY += subViewHeight + 10;
    }
    if (cancelButton) {
        cancelButton.frame = CGRectMake(10, subViewY, width - 20, subViewHeight);
    }
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        background.frame = CGRectMake(0, height - backgroundHeight, width, backgroundHeight);
    }];
}

#pragma mark - private

- (void)style {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.alpha = 0;
}

- (void)addBackground {
    background = [[UIView alloc] init];
    background.backgroundColor = [UIColor colorWithWhite:0.827 alpha:1];
    [self addSubview:background];
}

- (void)addTitle:(NSString *)title {
    backgroundHeight += subViewHeight + 10;
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithWhite:0.208 alpha:1];
    [background addSubview:titleLabel];
}

- (void)addPrimaryButton:(NSString *)primaryButtonTitle {
    backgroundHeight += subViewHeight + 10;
    primaryButton = [[UIButton alloc] init];
    [primaryButton setTitle:primaryButtonTitle forState:UIControlStateNormal];
    [self styleButton:primaryButton imageName:@"cancel-button"];
    [primaryButton addTarget:self
                     action:@selector(didClickPrimary:)
           forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:primaryButton];
}

- (void)addCancelButton:(NSString *)cancelButtonTitle {
    backgroundHeight += subViewHeight + 10;
    cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self styleButton:cancelButton imageName:@"done-button"];
    [cancelButton addTarget:self
                     action:@selector(didClickCancel:)
           forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:cancelButton];
}

- (void)styleButton:(UIButton *)button imageName:(NSString *)imageName {
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:[UIImage imageNamed:imageName]
                             forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-highlighted", imageName]]
                             forState:UIControlStateHighlighted];
    
}

- (void)didClickPrimary:(id)sender {
    if ([self.delegate respondsToSelector:@selector(primaryActionChosenForOptionsView:)]) {
        [self.delegate primaryActionChosenForOptionsView:self];
    }
    [self hide];
}

- (void)didClickCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelActionChosenForOptionsView:)]) {
        [self.delegate cancelActionChosenForOptionsView:self];        
    }
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        background.frame = CGRectMake(0, height, width, backgroundHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; 
    }];
}

@end
