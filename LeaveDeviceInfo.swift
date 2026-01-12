//
//  LeaveDeviceInfo.swift
//  FYDeviceSwift
//
//  Created by Computer  on 12/01/26.
//

import UIKit

class LeaveDeviceInfo: NSObject {
    static func getLeaveBaseInfo(uuid:String)->[String:Any]{
        let systemMemory = TravelAgencySystemMemory()
        let systemTime = TravelAgencySystemTime()
        let systemNetwork = TravelAgencySystemNetwork()
        let deviceUtil = TravelAgencyDeviceUtil()
        let infoEmpty = "null"
        var leaveBaseInfo:[String:String] = [:]
        leaveBaseInfo["uuid"] = uuid
        leaveBaseInfo["screenResolution"] = deviceUtil.leaveHappySystemScreenResolution()
        leaveBaseInfo["screenWidth"] = "\(Int(UIScreen.main.bounds.size.width))"
        leaveBaseInfo["screenHeight"] = "\(Int(UIScreen.main.bounds.size.height))"
        leaveBaseInfo["cpuNum"] = deviceUtil.leaveHappySystemCPUCoreCount()
        leaveBaseInfo["ramTotal"] = systemMemory.leaveHappyTotalMemorySize()
        leaveBaseInfo["ramCanUse"] = systemMemory.leaveHappyAvailableMemorySize()
        leaveBaseInfo["batteryLevel"] = "\(deviceUtil.leaveHappySystemBatteryLevel())"
        leaveBaseInfo["charged"] = deviceUtil.leaveHappySystemChargingStatus()
        leaveBaseInfo["totalBootTime"] = systemTime.leaveHappyBootDuration()
        leaveBaseInfo["totalBootTimeWake"] = systemTime.leaveHappyWakeUpDuration()
        leaveBaseInfo["defaultLanguage"] = deviceUtil.leaveHappySystemDefaultLanguage()
        leaveBaseInfo["defaultTimeZone"] = NSTimeZone.system.identifier;
        leaveBaseInfo["idfa"] = deviceUtil.leaveHappyDeviceAdvertisingID()
        leaveBaseInfo["idfv"] = UIDevice.current.identifierForVendor?.uuidString ?? infoEmpty
        leaveBaseInfo["phoneMark"] = UIDevice.current.name
        leaveBaseInfo["phoneType"] = deviceUtil.leaveHappyDeviceSystemModelName()
        leaveBaseInfo["systemVersions"] = UIDevice.current.systemVersion
        leaveBaseInfo["versionCode"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? infoEmpty
        leaveBaseInfo["network"] = systemNetwork.leaveHappyNetworkWorkTypeNumber()
        let currentSeameWifiDict = systemNetwork.leaveHappyWiFiNetworkWorkInfo()
        let currentWifiSSID = currentSeameWifiDict?["ssid"] ?? infoEmpty
        let currentWifiBSSID = currentSeameWifiDict?["bssid"] ?? infoEmpty
        leaveBaseInfo["wifiName"] = currentWifiSSID
        leaveBaseInfo["wifiBssid"] = currentWifiBSSID
        leaveBaseInfo["isvpn"] = systemNetwork.leaveHappyNetworkVPNWorkStatus()
        leaveBaseInfo["lastBootTime"] = systemTime.leaveHappyLastBootTimestamp()
        leaveBaseInfo["proxied"] = systemNetwork.leaveHappyNetworkProxyWorkStatus()
        leaveBaseInfo["simulated"] = deviceUtil.leaveHappyDeviceSystemModelName().contains("Simulator") == true ? "true" : "false"
        leaveBaseInfo["debugged"] = deviceUtil.leaveHappySystemDebugStatus()
        leaveBaseInfo["screenBrightness"] = deviceUtil.leaveHappySystemScreenBrightness()
        leaveBaseInfo["cashTotal"] = systemMemory.leaveHappyTotalDiskSpace()
        leaveBaseInfo["cashCanUse"] = systemMemory.leaveHappyAvailableDiskSpace()
        leaveBaseInfo["rooted"] = "false"
        return leaveBaseInfo
        
    }
}
