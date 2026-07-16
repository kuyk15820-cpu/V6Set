#import <UIKit/UIKit.h>

@interface LicenseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *licenseDict;
@property (nonatomic, strong) NSArray<NSString *> *sortedKeys;

@end
