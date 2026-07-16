#import "SettingsViewController.h"
#import "obfuscate.h"

// ประกาศ Private API ลับเพื่อให้ SettingsViewController สามารถดึงไอคอนของจริงมาแสดงผลได้เหมือนหน้าระบบความปลอดภัย
@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@implementation SettingsViewController {
    NSArray<NSString *> *_sectionTitles;
    NSDictionary<NSString *, NSArray<NSDictionary<NSString *, NSString *> *> *> *_tableData;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithUTF8String:AY_OBFUSCATE("หน้าหลัก")] 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:nil 
                                                                  action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    self.navigationController.navigationBar.tintColor = [UIColor linkColor];

    self.title = [NSString stringWithUTF8String:AY_OBFUSCATE("การตั้งค่า")];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    _sectionTitles = @[
        [NSString stringWithUTF8String:AY_OBFUSCATE("ข้อมูลแอป")], 
        [NSString stringWithUTF8String:AY_OBFUSCATE("เกี่ยวกับเรา")], 
        [NSString stringWithUTF8String:AY_OBFUSCATE("ประวัติการอัปเดต")]
    ];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"] ?: ([infoPlist objectForKey:@"CFBundleName"] ?: @"Application");
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier] ?: @"com.example.app";
    NSString *version = [infoPlist objectForKey:@"CFBundleShortVersionString"] ?: @"1.0";
    NSString *build = [infoPlist objectForKey:@"CFBundleVersion"] ?: @"1";
    NSString *fullVersion = [NSString stringWithFormat:@"v%@ (%@)", version, build];
    
    // ยุบข้อมูลของเซกชันแรกเหลือ Dictionary ชุดเดียวใน Array เพื่อให้วาดออกมาเพียงช่องเดียว
    _tableData = @{
        [NSString stringWithUTF8String:AY_OBFUSCATE("ข้อมูลแอป")]: @[
            @{@"title": appName, @"bundle": bundleID, @"version": fullVersion}
        ],
        [NSString stringWithUTF8String:AY_OBFUSCATE("เกี่ยวกับเรา")]: @[
            @{@"title": [NSString stringWithUTF8String:AY_OBFUSCATE("Developer")], @"value": [NSString stringWithUTF8String:AY_OBFUSCATE("@K02 (The-Genesis Team)")], @"icon": @"person.crop.circle"}
        ],
        [NSString stringWithUTF8String:AY_OBFUSCATE("ประวัติการอัปเดต")]: @[
            @{@"title": [NSString stringWithUTF8String:AY_OBFUSCATE("Total Updates")], @"value": [NSString stringWithUTF8String:AY_OBFUSCATE("3 Times")], @"icon": @"clock.arrow.circlepath"},
            @{@"title": [NSString stringWithUTF8String:AY_OBFUSCATE("Update #3")], @"value": [NSString stringWithUTF8String:AY_OBFUSCATE("2026-06-10")], @"icon": @"arrow.up.circle"},
            @{@"title": [NSString stringWithUTF8String:AY_OBFUSCATE("Update #2")], @"value": [NSString stringWithUTF8String:AY_OBFUSCATE("2026-03-15")], @"icon": @"arrow.up.circle"},
            @{@"title": [NSString stringWithUTF8String:AY_OBFUSCATE("Update #1")], @"value": [NSString stringWithUTF8String:AY_OBFUSCATE("2026-01-10")], @"icon": @"arrow.up.circle"}
        ]
    };
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _sectionTitles[section];
    return _tableData[sectionTitle].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = _sectionTitles[indexPath.section];
    NSDictionary *rowData = _tableData[sectionTitle][indexPath.row];
    
    NSString *cellIdentifier = (indexPath.section == 0) ? @"SingleAppInfoCell" : @"StandardSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        if (indexPath.section == 0) {
            // ใช้สไตล์ Subtitle เพื่อให้ชื่อแอปอยู่บน และ Bundle ID ตกลงมาอยู่ด้านล่างในช่องเดียวกัน
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
    }
    
    // ตั้งค่าสไตล์พื้นหลังธีมมืด
    cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil; // ล้างค่าเผื่อการ Reuse แถวอื่น
    
    if (indexPath.section == 0) {
        // 1. ชื่อแอป (แสดงผลซ้ายบนของช่อง)
        cell.textLabel.text = rowData[@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor labelColor];
        
        // 2. Bundle ID (แสดงผลถัดลงมาด้านล่างในช่องเดียวกัน)
        cell.detailTextLabel.text = rowData[@"bundle"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        
        // 3. เวอร์ชั่นขวาสุด: ใช้ UILabel ฝังลงใน accessoryView โดยระบบจะตรึงไว้ขวาสุดให้ทันทีโดยไม่ต้องตั้งค่าพิกัดเอง
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.text = rowData[@"version"];
        versionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        versionLabel.textColor = [UIColor secondaryLabelColor];
        [versionLabel sizeToFit]; // ให้ขนาดขยายตามความยาวตัวเลขเวอร์ชัน
        cell.accessoryView = versionLabel;
        
        // 4. ซ้ายมือสุดแสดงไอค่อนแอปดั้งเดิมจากระบบผ่าน Private API ลับ
        UIImage *appIcon = nil;
        NSString *currentBID = rowData[@"bundle"];
        if (currentBID && [UIImage respondsToSelector:@selector(_applicationIconImageForBundleIdentifier:format:scale:)]) {
            appIcon = [UIImage _applicationIconImageForBundleIdentifier:currentBID format:0 scale:[UIScreen mainScreen].scale];
        }
        
        if (!appIcon) {
            if (@available(iOS 14.0, *)) {
                cell.imageView.image = [UIImage systemImageNamed:[NSString stringWithUTF8String:AY_OBFUSCATE("app.window.checkmark")]];
                cell.imageView.tintColor = [UIColor labelColor];
            }
        } else {
            cell.imageView.image = appIcon;
            cell.imageView.tintColor = nil; // ปิดสีทับเพื่อให้ภาพดั้งเดิมของไอคอนแสดงเต็มสีปกติ
        }
        
    } else {
        // เซกชันมาตรฐานอื่นๆ (เกี่ยวกับเรา, ประวัติอัปเดต, ระบบ)
        cell.textLabel.text = rowData[@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor labelColor];
        
        cell.detailTextLabel.text = rowData[@"value"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        
        if (rowData[@"icon"] && [rowData[@"icon"] length] > 0) {
            cell.imageView.image = [UIImage systemImageNamed:rowData[@"icon"]];
            cell.imageView.tintColor = [UIColor labelColor];
        }
        
        // ตกแต่งปุ่มตามประเภทเงื่อนไข
        if ([rowData[@"value"] isEqualToString:[NSString stringWithUTF8String:AY_OBFUSCATE("@K02 (The-Genesis Team)")]]) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = [UIColor secondaryLabelColor];
        header.textLabel.font = [UIFont boldSystemFontOfSize:13];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // แถวแรกข้อมูลแอปให้ดึงความสูงพอดีตามเนื้อหาที่มีไอคอนใหญ่ ส่วนแถวอื่นใช้ความสูงมาตรฐานของระบบอัตโนมัติ
    return (indexPath.section == 0) ? 65.0f : UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *sectionTitle = _sectionTitles[indexPath.section];
    NSDictionary *rowData = _tableData[sectionTitle][indexPath.row];
    
    if ([rowData[@"value"] isEqualToString:[NSString stringWithUTF8String:AY_OBFUSCATE("@K02 (The-Genesis Team)")]]) {
        NSURL *telegramURL = [NSURL URLWithString:[NSString stringWithUTF8String:AY_OBFUSCATE("https://t.me/K02_TH")]];
        if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
            [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        }
    }
}

@end