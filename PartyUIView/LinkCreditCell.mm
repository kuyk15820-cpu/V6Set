#import "LinkCreditCell.h"

@implementation LinkCreditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // ให้ไฮไลท์ตอนกดสไตล์ดั้งเดิม ถ้าไม่มี URL ค่อยปิดใน configure
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 1. Setup Credit Avatar Icon (ทรงสี่เหลี่ยมโค้งตามบล็อก else ของ iOS < 19)
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.backgroundColor = [UIColor systemGray6Color];
    self.avatarImageView.layer.cornerRadius = 12.0;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 1.0;
    self.avatarImageView.layer.borderColor = [[UIColor labelColor] colorWithAlphaComponent:0.2].CGColor;
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.avatarImageView];
    
    // 2. Setup Container สำหรับ Labels (VStack)
    UIView *labelContainer = [[UIView alloc] init];
    labelContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:labelContainer];
    
    // Name Label
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    self.nameLabel.textColor = [UIColor labelColor];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [labelContainer addSubview:self.nameLabel];
    
    // Description Label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15]; // เทียบเท่า .subheadline
    self.descriptionLabel.textColor = [UIColor secondaryLabelColor];
    self.descriptionLabel.numberOfLines = 0; // รองรับ multiline
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [labelContainer addSubview:self.descriptionLabel];
    
    // 3. Setup Chevron (ลูกศรชี้ขวา)
    self.chevronImageView = [[UIImageView alloc] init];
    // ใช้ UIImageSymbolConfiguration เพื่อให้ได้ความหนาแบบ Semibold และขนาด Small ตาม SwiftUI
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:14 
                                                                                     weight:UIImageSymbolWeightSemibold 
                                                                                      scale:UIImageSymbolScaleSmall];
    self.chevronImageView.image = [UIImage systemImageNamed:@"chevron.right" withConfiguration:config];
    self.chevronImageView.tintColor = [UIColor tertiaryLabelColor];
    self.chevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.chevronImageView];
    
    // --- Layout Constraints (จัดระยะห่าง spacing: 16 ตามสไตล์ iOS < 19) ---
    [NSLayoutConstraint activateConstraints:@[
        // ข้อจำกัดของ Avatar (ขนาด 40x40 ยึดซ้าย)
        [self.avatarImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.avatarImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.avatarImageView.widthAnchor constraintEqualToConstant:40],
        [self.avatarImageView.heightAnchor constraintEqualToConstant:40],
        
        // ข้อจำกัดของ Container ข้อความ
        [labelContainer.leadingAnchor constraintEqualToAnchor:self.avatarImageView.trailingAnchor constant:16],
        [labelContainer.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        // ข้อจำกัดภายใน Container ข้อความ
        [self.nameLabel.topAnchor constraintEqualToAnchor:labelContainer.topAnchor],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:labelContainer.leadingAnchor],
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:labelContainer.trailingAnchor],
        
        [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:2],
        [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:labelContainer.leadingAnchor],
        [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:labelContainer.trailingAnchor],
        [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:labelContainer.bottomAnchor],
        
        // ข้อจำกัดของลูกศร Chevron (ยึดขวา)
        [self.chevronImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.chevronImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [labelContainer.trailingAnchor constraintEqualToAnchor:self.chevronImageView.leadingAnchor constant:-8],
        
        // ขยายความสูงขั้นต่ำของเซลล์
        [self.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:60]
    ]];
}

// เมธอดสำหรับโยนข้อมูลเข้ามาอัปเดต UI
- (void)configureWithImage:(UIImage *)image name:(NSString *)name description:(NSString *)description url:(NSString *)url {
    self.avatarImageView.image = image;
    self.nameLabel.text = name;
    self.descriptionLabel.text = description;
    self.urlString = url;
    
    // ตรวจสอบว่าถ้าไม่มี URL ให้ซ่อนลูกศร และไม่เปิดให้กดไฮไลท์เซลล์
    if (!url || url.length == 0) {
        self.chevronImageView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.chevronImageView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

@end
