//
//  LeaveDeviceInfo.swift
//  FYDeviceSwift_Example
//
//  Created by Computer  on 12/01/26.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

@objcMembers
public class FYDeviceInfo: NSObject {
    public static func getDeviceInfo(uuid:String)->[String:Any]{
        let systemMemory = FYDeviceMemory()
        let systemTime = FYDeviceTime()
        let systemNetwork = FYDeviceNetwork()
        let deviceUtil = FYDeviceUtil()
        let infoEmpty = "null"
        var leaveBaseInfo:[String:String] = [:]
        leaveBaseInfo["uuid"] = uuid
        leaveBaseInfo["screenResolution"] = deviceUtil.screenResolution()
        leaveBaseInfo["screenWidth"] = "\(Int(UIScreen.main.bounds.size.width))"
        leaveBaseInfo["screenHeight"] = "\(Int(UIScreen.main.bounds.size.height))"
        leaveBaseInfo["cpuNum"] = deviceUtil.cpuCoreCount()
        leaveBaseInfo["ramTotal"] = systemMemory.totalMemorySize()
        leaveBaseInfo["ramCanUse"] = systemMemory.availableMemorySize()
        leaveBaseInfo["batteryLevel"] = "\(deviceUtil.batteryLevel())"
        leaveBaseInfo["charged"] = deviceUtil.chargingStatus()
        leaveBaseInfo["totalBootTime"] = systemTime.bootDuration()
        leaveBaseInfo["totalBootTimeWake"] = systemTime.wakeUpDuration()
        leaveBaseInfo["defaultLanguage"] = deviceUtil.defaultLanguage()
        leaveBaseInfo["defaultTimeZone"] = NSTimeZone.system.identifier;
        leaveBaseInfo["idfa"] = deviceUtil.advertisingID()
        leaveBaseInfo["idfv"] = UIDevice.current.identifierForVendor?.uuidString ?? infoEmpty
        leaveBaseInfo["phoneMark"] = UIDevice.current.name
        leaveBaseInfo["phoneType"] = deviceUtil.deviceModelName()
        leaveBaseInfo["systemVersions"] = UIDevice.current.systemVersion
        leaveBaseInfo["versionCode"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? infoEmpty
        leaveBaseInfo["network"] = systemNetwork.networkTypeNumber()
        let currentSeameWifiDict = systemNetwork.wifiInfo()
        let currentWifiSSID = currentSeameWifiDict?["ssid"] ?? infoEmpty
        let currentWifiBSSID = currentSeameWifiDict?["bssid"] ?? infoEmpty
        leaveBaseInfo["wifiName"] = currentWifiSSID
        leaveBaseInfo["wifiBssid"] = currentWifiBSSID
        leaveBaseInfo["isvpn"] = systemNetwork.vpnStatus()
        leaveBaseInfo["lastBootTime"] = systemTime.lastBootTimestamp()
        leaveBaseInfo["proxied"] = systemNetwork.proxyStatus()
        leaveBaseInfo["simulated"] = deviceUtil.deviceModelName().contains("Simulator") == true ? "true" : "false"
        leaveBaseInfo["debugged"] = deviceUtil.debugStatus()
        leaveBaseInfo["screenBrightness"] = deviceUtil.screenBrightness()
        leaveBaseInfo["cashTotal"] = systemMemory.totalDiskSpace()
        leaveBaseInfo["cashCanUse"] = systemMemory.availableDiskSpace()
        leaveBaseInfo["rooted"] = "false"
        return leaveBaseInfo
        
    }
}
