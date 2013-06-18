#import <UIKit/UIKit.h>

@class List;
@protocol ListEditorDelegate;

@interface ListCollectionCell : UICollectionViewCell <UITextFieldDelegate>

@property(nonatomic, weak) id<ListEditorDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *listNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *listNameTextField;

- (void)configureCellWithList:(List *)list;
- (void)enterEditMode;

@end

@protocol ListEditorDelegate <NSObject>

- (void)didFinishEditingList:(NSString *)listName cell:(ListCollectionCell *)cell;

@end
