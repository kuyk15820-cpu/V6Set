//
//  SettingsViewPresenter.swift
//
//  Created by lunginspector on 1/11/26.
//

import SwiftUI
import UIKit

@objc(SettingsViewPresenter)
class SettingsViewPresenter: NSObject {
    
    // สร้างตัวแปรเก็บ Controller รอไว้ในหน่วยความจำ (Pre-warmed Instance)
    private static var cachedController: UIHostingController<SettingsView>?
    
    // ฟังก์ชันสำหรับเรียกอุ่นเครื่องตั้งแต่ viewDidLoad ของหน้าจอหลัก
    @objc class func warmUp() {
        DispatchQueue.main.async {
            if self.cachedController == nil {
                let settingsView = SettingsView()
                let hostingController = UIHostingController(rootView: settingsView)
                hostingController.modalPresentationStyle = .pageSheet
                self.cachedController = hostingController
            }
        }
    }
    
    @objc class func presentSettingsFromViewController(_ viewController: UIViewController) {
        // ดึงตัวที่สร้างรอไว้มาแสดงผลทันที (ไม่หน่วงแน่นอน)
        if let controller = self.cachedController {
            // ป้องกันกรณีกำลังพรีเซนต์ซ้ำซ้อนอยู่
            if controller.presentingViewController == nil {
                viewController.present(controller, animated: true, completion: nil)
            }
        } else {
            // Fallback กรณีที่เครื่องยังไม่ได้ Warm-up ทัน (เช่นกดเร็วมากทันทีที่แอปเปิด)
            let settingsView = SettingsView()
            let hostingController = UIHostingController(rootView: settingsView)
            hostingController.modalPresentationStyle = .pageSheet
            self.cachedController = hostingController
            viewController.present(hostingController, animated: true, completion: nil)
        }
    }
}
