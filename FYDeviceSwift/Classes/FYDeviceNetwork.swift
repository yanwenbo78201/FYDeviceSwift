import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony

@objcMembers
public class FYDeviceNetwork: NSObject {
    
    // 检查VPN连接状态
    public func vpnStatus() -> String {
        guard let networkSystemProxy = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] else {
            return "false"
        }
        
        guard let proxySCOPEMap = networkSystemProxy["__SCOPED__"] as? [String: Any] else {
            return "false"
        }
        
        let vpnKeys = ["tap", "tun", "ipsec", "ppp"]
        for key in proxySCOPEMap.keys {
            for vpnKey in vpnKeys {
                if key.contains(vpnKey) {
                    return "true"
                }
            }
        }
        return "false"
    }

    // 检查代理连接状态
    public func proxyStatus() -> String {
        guard let systemProxyConfig = CFNetworkCopySystemProxySettings()?.takeRetainedValue() else {
            return "false"
        }
        
        let systemProxys = CFNetworkCopyProxiesForURL(URL(string: "https://www.apple.com")! as CFURL, systemProxyConfig).takeRetainedValue() as NSArray
        if systemProxys.count <= 0 {
            return "false"
        }
        
        guard let systemProxy = systemProxys.object(at: 0) as? NSDictionary else {
            return "false"
        }
        
        guard let proxyType = systemProxy.object(forKey: kCFProxyTypeKey) as? String else {
            return "false"
        }
        
        return proxyType == "kCFProxyTypeNone" ? "false" : "true"
    }


    // 获取网络类型的数字编码
    public func networkTypeNumber() -> String {
        let detailNetworkType = networkTypeDetail()
        
        switch detailNetworkType {
        case "Unknown":
            return "0"
        case "WiFi":
            return "1"
        case "2G":
            return "2"
        case "3G":
            return "3"
        case "4G":
            return "4"
        case "5G":
            return "5"
        default:
            return "0"
        }
    }

    // 获取详细的网络类型
    public func networkTypeDetail() -> String {
        var sockaddrAddress = sockaddr_in()
        sockaddrAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        sockaddrAddress.sin_family = sa_family_t(AF_INET)
        
        let routeReachability = withUnsafePointer(to: &sockaddrAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var reachabilityFlags: SCNetworkReachabilityFlags = []
        guard let reachability = routeReachability,
              SCNetworkReachabilityGetFlags(reachability, &reachabilityFlags) else {
            return "Unknown"
        }
        
        let reachableStatus = reachabilityFlags.contains(.reachable)
        let needsConnection = reachabilityFlags.contains(.connectionRequired)
        
        if !reachableStatus || needsConnection {
            return "notReachable"
        }
        
        if reachabilityFlags.contains(.isWWAN) {
            return mobileNetworkType()
        }
        
        return "WiFi"
    }

    // 获取移动网络类型
    private func mobileNetworkType() -> String {
        let telephonyNetworkInfo = CTTelephonyNetworkInfo()
        
        var networkType: String?
        if #available(iOS 12.1, *) {
            if let accessRadioDict = telephonyNetworkInfo.serviceCurrentRadioAccessTechnology {
                if let accessRadioKey = Array(accessRadioDict.keys).first, accessRadioKey.count > 0 {
                    networkType = accessRadioDict[accessRadioKey]
                }
            }
        } else {
            networkType = telephonyNetworkInfo.currentRadioAccessTechnology
        }
        
        guard let type = networkType else {
            return "notReachable"
        }
        
        if #available(iOS 14.1, *) {
            if type == CTRadioAccessTechnologyNRNSA || type == CTRadioAccessTechnologyNR {
                return "5G"
            }
        }
        
        if type == CTRadioAccessTechnologyLTE {
            return "4G"
        } else if [CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD].contains(type) {
            return "3G"
        } else if [CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyCDMA1x].contains(type) {
            return "2G"
        } else {
            return "notReachable"
        }
    }

    // 获取WiFi详细信息
    public func wifiInfo() -> [String: String]? {
        guard let interfaces = CNCopySupportedInterfaces() as NSArray? else {
            return nil
        }
        
        for interface in interfaces {
            if let interfaceName = interface as? String,
               let interfaceInfo = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                if let ssid = interfaceInfo[kCNNetworkInfoKeySSID] as? String,
                   let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID] as? String {
                    return ["ssid": ssid, "bssid": bssid]
                }
            }
        }
        return nil
    }
}

