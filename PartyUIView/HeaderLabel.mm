#import "HeaderLabel.h"

@implementation HeaderLabel

- (instancetype)initWithText:(NSString *)text icon:(NSString *)icon {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupViewsWithText:text icon:icon];
    }
    return self;
}

- (void)setupViewsWithText:(NSString *)text icon:(NSString *)icon {
    // 1. Setup Icon ImageView (จำลองตามสเปค iOS < 19: ขนาด width 18pt และจัดเซ็นเตอร์)
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.image = [UIImage systemImageNamed:icon];
    self.iconImageView.tintColor = [UIColor secondaryLabelColor];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.iconImageView];
    
    // 2. Setup Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = text;
    // ปรับรูปแบบ Font ให้เป็นตัวพิมพ์ใหญ่ตามมาตรฐาน Header ของ UITableView
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.titleLabel.textColor = [UIColor secondaryLabelColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    
    // --- Layout Constraints (จัดระยะชิดซ้าย-ขวา และมีระยะห่าง spacing: 8) ---
    [NSLayoutConstraint activateConstraints:@[
        // บังคับความกว้างไอคอนเป็น 18pt ตามโค้ด SwiftUI เดิม
        [self.iconImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.iconImageView.widthAnchor constraintEqualToConstant:18],
        [self.iconImageView.heightAnchor constraintEqualToConstant:18],
        
        // จัดให้ข้อความห่างจากไอคอน 8pt (spacing: 8)
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:8],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20]
    ]];
}

@end
