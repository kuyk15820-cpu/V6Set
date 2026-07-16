#import "AppInfoCell.h"

@implementation AppInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 1. Placeholder Background สำหรับ App Icon
    UIView *iconBackground = [[UIView alloc] init];
    iconBackground.backgroundColor = [UIColor systemGray5Color];
    iconBackground.layer.cornerRadius = 14.0;
    iconBackground.layer.masksToBounds = YES;
    iconBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:iconBackground];
    
    // 2. Setup App Icon ImageView
    self.appIconImageView = [[UIImageView alloc] init];
    self.appIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.appIconImageView.layer.cornerRadius = 14.0;
    self.appIconImageView.layer.masksToBounds = YES;
    
    // โหลดไอคอนแอปเริ่มต้น ถ้าไม่มีให้ใช้ระบบ Questionmark Square เป็น Placeholder
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconFiles = [[[infoPlist objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
NSString *iconName = [iconFiles lastObject];
    UIImage *appIcon = [UIImage imageNamed:iconName];
    
    if (appIcon) {
        self.appIconImageView.image = appIcon;
    } else {
        self.appIconImageView.image = [UIImage systemImageNamed:@"questionmark.square"];
        self.appIconImageView.tintColor = [UIColor secondaryLabelColor];
    }
    
    self.appIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.appIconImageView];
    
    // ทำขอบเบลอเบาๆ เลียนแบบ .stroke(Color.secondary.opacity(0.2)) ใน SwiftUI
    self.appIconImageView.layer.borderWidth = 1.5;
    self.appIconImageView.layer.borderColor = [[UIColor secondaryLabelColor] colorWithAlphaComponent:0.2].CGColor;
    
    // 3. Stack/Container สำหรับ Labels (VStack ลำดับแนวตั้ง)
    UIView *labelContainer = [[UIView alloc] init];
    labelContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:labelContainer];
    
    // App Name Label (ตัวหนา)
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold]; // เทียบเท่า .title3, weight: .semibold
    self.appNameLabel.textColor = [UIColor labelColor];
    
    // ดึงชื่อแอปอัตโนมัติ
    NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [infoPlist objectForKey:@"CFBundleName"];
    self.appNameLabel.text = appName ? appName : @"App Name";
    self.appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [labelContainer addSubview:self.appNameLabel];
    
    // App Version Label
    self.appVersionLabel = [[UILabel alloc] init];
    self.appVersionLabel.font = [UIFont systemFontOfSize:15];
    self.appVersionLabel.textColor = [UIColor secondaryLabelColor];
    self.appVersionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [labelContainer addSubview:self.appVersionLabel];
    
    // --- Layout Constraints (Auto Layout สำหรับจัดตำแหน่งเหมือน HStack และ VStack) ---
    [NSLayoutConstraint activateConstraints:@[
        // ข้อจำกัดของ Icon (ขนาด 64x64 ยึดฝั่งซ้าย ระยะห่าง 14pt ตาม spacing: 14)
        [iconBackground.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [iconBackground.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [iconBackground.widthAnchor constraintEqualToConstant:64],
        [iconBackground.heightAnchor constraintEqualToConstant:64],
        
        [self.appIconImageView.leadingAnchor constraintEqualToAnchor:iconBackground.leadingAnchor],
        [self.appIconImageView.trailingAnchor constraintEqualToAnchor:iconBackground.trailingAnchor],
        [self.appIconImageView.topAnchor constraintEqualToAnchor:iconBackground.topAnchor],
        [self.appIconImageView.bottomAnchor constraintEqualToAnchor:iconBackground.bottomAnchor],
        
        // ข้อจำกัดของ Container ข้อความ
        [labelContainer.leadingAnchor constraintEqualToAnchor:self.appIconImageView.trailingAnchor constant:14],
        [labelContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [labelContainer.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        // ข้อจำกัดภายใน Container ข้อความ (VStack)
        [self.appNameLabel.topAnchor constraintEqualToAnchor:labelContainer.topAnchor],
        [self.appNameLabel.leadingAnchor constraintEqualToAnchor:labelContainer.leadingAnchor],
        [self.appNameLabel.trailingAnchor constraintEqualToAnchor:labelContainer.trailingAnchor],
        
        [self.appVersionLabel.topAnchor constraintEqualToAnchor:self.appNameLabel.bottomAnchor constant:2],
        [self.appVersionLabel.leadingAnchor constraintEqualToAnchor:labelContainer.leadingAnchor],
        [self.appVersionLabel.trailingAnchor constraintEqualToAnchor:labelContainer.trailingAnchor],
        [self.appVersionLabel.bottomAnchor constraintEqualToAnchor:labelContainer.bottomAnchor],
        
        // กำหนดส่วนสูงของเซลล์ให้ขยายพอดีตัวแอปคอน
        [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:80]
    ]];
}

// ฟังก์ชันระบุ Build เข้าไปตอนเอาเซลล์ไปใช้ใน TableView
- (void)configureWithBuild:(NSString *)build {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoPlist objectForKey:@"CFBundleShortVersionString"];
    if (!version) version = @"1.0.0";
    
    if (build && build.length > 0) {
        self.appVersionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)", version, build];
    } else {
        self.appVersionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    }
}

@end
