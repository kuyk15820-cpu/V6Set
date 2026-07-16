#import "LicenseViewController.h"
#import "GetLicenseDict.h"
#import "LicenseDetailsViewController.h" // สร้างต่อด้านล่าง

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Licenses";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // โหลดข้อมูลดิบจาก Helper
    self.licenseDict = [GetLicenseDict getLicenseDict];
    
    // ทำการดึง Key และ Sort ลำดับตัวอักษรเหมือน .keys.sorted() ใน Swift
    self.sortedKeys = [[self.licenseDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // สร้าง UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LicenseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // ลูกศรชี้ขวา (NavigationLink)
    }
    
    NSString *fileName = self.sortedKeys[indexPath.row];
    NSArray *splitName = [fileName componentsSeparatedByString:@"_"];
    
    // แยกเครดิตเหมือน splitName.last
    NSString *creditor = splitName.count > 1 ? splitName.lastObject : fileName;
    
    cell.textLabel.text = creditor;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *fileName = self.sortedKeys[indexPath.row];
    NSString *licenseText = self.licenseDict[fileName];
    
    NSArray *splitName = [fileName componentsSeparatedByString:@"_"];
    NSString *license = splitName.firstObject;
    NSString *creditor = splitName.count > 1 ? splitName.lastObject : @"";
    
    // ตั้งชื่อเรื่องคล้าย Swift "License Name License | Creditor Name"
    NSString *detailTitle = [NSString stringWithFormat:@"%@ License | %@", license, creditor];
    
    // นำทางไปยังหน้าดูรายละเอียด
    LicenseDetailsViewController *detailsVC = [[LicenseDetailsViewController alloc] initWithName:detailTitle licenseText:licenseText];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

@end
