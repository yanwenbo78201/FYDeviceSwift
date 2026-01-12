
import UIKit
import AppTrackingTransparency
import AdSupport

// 设备标识符相关功能
@objcMembers
public class FYDeviceIdentifier: NSObject {
    
    // 获取IDFA广告标识符
    public func advertisingID() -> String {
        var deviceIDFA = "null"
        
        if #available(iOS 14.0, *) {
            let semaphore = DispatchSemaphore(value: 0)
            
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    deviceIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
                semaphore.signal()
            }
            
            semaphore.wait()
        } else {
            deviceIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        
        return deviceIDFA
    }
}
