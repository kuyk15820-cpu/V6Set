#import <UIKit/UIKit.h>

@interface AppInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *appIconImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appVersionLabel;

- (void)configureWithBuild:(NSString *)build;

@end
