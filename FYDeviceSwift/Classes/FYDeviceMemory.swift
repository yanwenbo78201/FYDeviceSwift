

import UIKit
import Darwin

@objcMembers
public class FYDeviceMemory: NSObject {
    
    // 获取总内存大小（GB）
    public func totalMemorySize() -> String {
        let systemPhysicalMemory = ProcessInfo.processInfo.physicalMemory
        var totalMemory = (Double(systemPhysicalMemory) / 1024.0) / 1024.0
        
        let reservedMemory = 256
        let reservedMemoryRemainder = Int(totalMemory) % reservedMemory
        if reservedMemoryRemainder >= reservedMemory / 2 {
            totalMemory = Double(Int(totalMemory) - reservedMemoryRemainder + 256)
        } else {
            totalMemory = Double(Int(totalMemory) - reservedMemoryRemainder)
        }
        
        if totalMemory <= 0 {
            totalMemory = -1
        }
        
        return String(format: "%.6f", totalMemory / 1024.0)
    }
        
    // 获取可用内存大小（GB）
    public func availableMemorySize() -> String {
        let hostPort = mach_host_self()
        var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        var pageSize: vm_size_t = 0
        
        if host_page_size(hostPort, &pageSize) != KERN_SUCCESS {
            print("获取页面大小失败")
            return "-1"
        }
        
        var vmStat = vm_statistics_data_t()
        let result = withUnsafeMutablePointer(to: &vmStat) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) { reboundedPointer in
                host_statistics(hostPort, HOST_VM_INFO, reboundedPointer, &hostSize)
            }
        }
        
        if result != KERN_SUCCESS {
            print("获取虚拟内存统计信息失败")
            return "-1"
        }
        
        let virtualMemoryUsed = UInt(vmStat.active_count + vmStat.inactive_count + vmStat.wire_count) * pageSize
        print(virtualMemoryUsed)
        
        let totalMemorySize = Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        let useMemorySize = Double(virtualMemoryUsed) / 1024.0 / 1024.0
        let canMemoryUseSize = (totalMemorySize - useMemorySize) / 1024.0
        return String(format: "%.6f", canMemoryUseSize)
    }
        

    // 获取总磁盘空间
    public func totalDiskSpace() -> String {
        if let diskAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalDiskSize = diskAttributes[.systemSize] as? Int, totalDiskSize > 0 {
            return formatDiskBytes(totalDiskSize)
        }
        return "0"
    }
    
    // 获取可用磁盘空间
    public func availableDiskSpace() -> String {
        if let diskAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeDiskSize = diskAttributes[.systemFreeSize] as? Int, freeDiskSize > 0 {
            return formatDiskBytes(freeDiskSize)
        }
        return "0"
    }
        
    // 格式化字节大小
    private func formatDiskBytes(_ cashSize: Int) -> String {
        let transByteTotalNum = Double(cashSize)
        let transGNum = transByteTotalNum / (1024 * 1024 * 1024)
        return String(format: "%.6f", transGNum)
        
    }
}
