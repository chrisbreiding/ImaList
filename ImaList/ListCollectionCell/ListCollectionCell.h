#import <UIKit/UIKit.h>

@class List;
@protocol ListEditorDelegate;

@interface ListCollectionCell : UICollectionViewCell <UITextFieldDelegate>

@property(nonatomic, weak) id<ListEditorDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *listNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *listNameTextField;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

- (IBAction)deleteList:(id)sender;
- (void)configureCellWithList:(List *)list editing:(BOOL)editing;
- (void)enterEditingMode;

@end

@protocol ListEditorDelegate <NSObject>

- (void)didFinishEditingList:(NSString *)listName cell:(ListCollectionCell *)cell;
- (void)deleteListForCell:(ListCollectionCell *)cell;

@end
