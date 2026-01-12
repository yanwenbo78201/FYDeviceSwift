
import UIKit
import CoreTelephony

// 设备工具类 - 聚合各个功能类
@objcMembers
public class FYDeviceUtil: NSObject {
    
    private let identifier = FYDeviceIdentifier()
    private let model = FYDeviceModel()
    private let systemStatus = FYDeviceSystemStatus()
    
    // MARK: - 设备标识符相关
    public func advertisingID() -> String {
        return identifier.advertisingID()
    }
    
    // MARK: - 设备型号相关
    public func deviceModelName() -> String {
        return model.deviceModelName()
    }
    
    public func deviceTypeNumber() -> String {
        return model.deviceTypeNumber()
    }
    
    public func deviceUAType() -> String {
        return model.deviceUAType()
    }
    
    // MARK: - 系统状态相关
    public func screenResolution() -> String {
        return systemStatus.screenResolution()
    }
    
    public func screenBrightness() -> String {
        return systemStatus.screenBrightness()
    }
    
    public func cpuCoreCount() -> String {
        return systemStatus.cpuCoreCount()
    }
    
    public func batteryLevel() -> String {
        return systemStatus.batteryLevel()
    }
    
    public func chargingStatus() -> String {
        return systemStatus.chargingStatus()
    }
    
    public func defaultLanguage() -> String {
        return systemStatus.defaultLanguage()
    }
    
    public func debugStatus() -> String {
        return systemStatus.debugStatus()
    }
}

@objcMembers
public class FYSMIModel: NSObject {
    public var slotNumber: Int = 0
    public var cardsNumber: Int = 0
    public var firstOperator: String = ""
    public var secondOperator: String = ""
    
    public override init() {
        super.init()
    }
}

