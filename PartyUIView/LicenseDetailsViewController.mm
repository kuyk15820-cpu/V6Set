#import "LicenseDetailsViewController.h"

@implementation LicenseDetailsViewController

- (instancetype)initWithName:(NSString *)name licenseText:(NSString *)text {
    self = [super init];
    if (self) {
        _licenseName = name;
        _licenseText = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // สร้าง UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// ใช้กำหนดหัว Header ข้อความเท่ๆ เหมือน SwiftUI HeaderLabel
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.licenseName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LicenseDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0; // แสดงแบบ Multi-line
        
        // ใช้ Font Monospaced .subheadline เหมือนโค้ดเดิม
        cell.textLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:13.0];
        cell.textLabel.textColor = [UIColor labelColor];
    }
    
    cell.textLabel.text = self.licenseText;
    return cell;
}

#pragma mark - Context Menu (iOS 13+ สำหรับจำลอง .contextMenu ของ SwiftUI เพื่อคัดลอกข้อความ)

- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                   previewProvider:nil
                                                    actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        UIAction *copyAction = [UIAction actionWithTitle:@"Copy to Clipboard"
                                                   image:[UIImage systemImageNamed:@"doc.on.doc"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            [UIPasteboard generalPasteboard].string = self.licenseText;
        }];
        
        return [UIMenu menuWithTitle:@"" children:@[copyAction]];
    }];
}

@end
