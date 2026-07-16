#import <UIKit/UIKit.h>

@interface LicenseDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *licenseName;
@property (nonatomic, strong) NSString *licenseText;

- (instancetype)initWithName:(NSString *)name licenseText:(NSString *)text;

@end
