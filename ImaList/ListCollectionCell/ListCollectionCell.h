#import <UIKit/UIKit.h>

@class List;
@protocol ListCellDelegate;

@interface ListCollectionCell : UICollectionViewCell

@property(nonatomic, weak) id<ListCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *listNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *importantCountLabel;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, strong) List *list;

- (IBAction)didTapDelete:(id)sender;
- (void)configureCellWithList:(List *)list editing:(BOOL)isEditing current:(BOOL)isCurrent;

@end

@protocol ListCellDelegate <NSObject>

- (void)deleteList:(List *)list;

@end
