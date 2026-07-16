#import <UIKit/UIKit.h>

@interface LinkCreditCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *chevronImageView;
@property (nonatomic, strong) NSString *urlString;

- (void)configureWithImage:(UIImage *)image name:(NSString *)name description:(NSString *)description url:(NSString *)url;

@end
