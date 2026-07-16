#import <UIKit/UIKit.h>

@interface HeaderLabel : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithText:(NSString *)text icon:(NSString *)icon;

@end
