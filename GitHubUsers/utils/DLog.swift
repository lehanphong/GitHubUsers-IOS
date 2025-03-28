import Foundation

struct DLog {
    private static let TAG = "GitHubUser"
    private static let isShowLog = true
    
    static func d(_ debug : String?) {
        if isShowLog {
            NSLog("DEBUG: %@", debug ?? "null")
        }
    }
    
    static func i(_ info : String?) {
        if isShowLog {
            if let info = info, info.count > 1024 {
                print("\(Date()) INFO: \(info)")
            } else {
                NSLog("INFO: %@", info ?? "null")
            }
        }
    }
    
    static func w(_ warning : String?) {
    
        if isShowLog {
            NSLog("WARNING: %@", warning ?? "null")
        }
    }
    
    static func e(_ error : String?) {
        if isShowLog {
            NSLog("ERROR: %@", error ?? "null")
        }
    }
}
