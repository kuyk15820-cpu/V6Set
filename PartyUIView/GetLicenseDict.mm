#import "GetLicenseDict.h"

@implementation GetLicenseDict

+ (NSDictionary<NSString *, NSString *> *)getLicenseDict {
    NSMutableDictionary *licenseDict = [NSMutableDictionary dictionary];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    
    NSError *error = nil;
    NSArray<NSURL *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:bundleURL
                                                               includingPropertiesForKeys:nil
                                                                                  options:0
                                                                                    error:&error];
    if (!error && contents) {
        for (NSURL *url in contents) {
            NSString *fileName = [[url URLByDeletingPathExtension] lastPathComponent];
            NSString *fileExtension = [url pathExtension];
            
            // คัดกรองเฉพาะไฟล์ .txt ที่มีเครื่องหมาย _ (ขีดล่าง)
            if ([fileName containsString:@"_"] && [fileExtension isEqualToString:@"txt"]) {
                NSString *licenseText = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
                if (licenseText) {
                    licenseDict[fileName] = licenseText;
                }
            }
        }
    }
    return [licenseDict copy];
}

@end
