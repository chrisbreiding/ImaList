#import <UIKit/UIKit.h>

@protocol OptionsViewDelegate;

@interface OptionsView : UIView

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<OptionsViewDelegate>)delegate
           primaryButtonTitle:(NSString *)primaryButtonTitle
            cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)showInView:(UIView *)view;

@end

@protocol OptionsViewDelegate <NSObject>

@optional
- (void)primaryActionChosenForOptionsView:(OptionsView *)optionsView;
- (void)cancelActionChosenForOptionsView:(OptionsView *)optionsView;

@end