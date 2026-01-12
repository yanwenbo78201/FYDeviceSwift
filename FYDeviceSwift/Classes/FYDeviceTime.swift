
import UIKit
import Darwin

@objcMembers
public class FYDeviceTime: NSObject {
    
    // 获取系统总运行时间（毫秒）
    public func bootDuration() -> String {
        var bootTime = timeval()
        var timevalSize = MemoryLayout<timeval>.stride
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var nowTime = timeval()
        var currentZone = timezone()
        
        gettimeofday(&nowTime, &currentZone)
        _ = sysctl(&mib, UInt32(mib.count), &bootTime, &timevalSize, nil, 0)
        
        var resultBootTime: Int = 0
        if bootTime.tv_sec != 0 {
            resultBootTime = (nowTime.tv_sec - bootTime.tv_sec) * 1000
            resultBootTime += Int((nowTime.tv_usec - bootTime.tv_usec)) / 1000
        }
        return "\(resultBootTime)"
    }
    
    // 获取系统唤醒时间（毫秒）
    public func wakeUpDuration() -> String {
        return "\(Int(ProcessInfo.processInfo.systemUptime * 1000))"
    }
    
    // 获取上次开机时间戳
    public func lastBootTimestamp() -> String {
        if let bootDurationMs = Double(bootDuration()) {
            let bootSecondsInterval = bootDurationMs / 1000.0
            let bootTimeDate = Date(timeIntervalSinceNow: (-bootSecondsInterval))
            let lastBootStamp = bootTimeDate.timeIntervalSince1970 * 1000
            return "\(Int(lastBootStamp))"
        } else {
            return "0"
        }
    }
}

