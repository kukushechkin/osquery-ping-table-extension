import Foundation
import os.log

import SwiftyPing

@objc
public class SwiftyPing_wrapper: NSObject {
    static let queue = DispatchQueue(label: "SwiftyPing_wrapper")
    static let log = OSLog(subsystem: "com.kukushechkin.osquery-ping", category: "SwiftyPing_wrapper")

    @objc
    public class func latencyForDestination(dest: String) -> Double {
        let config = PingConfiguration(interval: 0.5, with: 5)
        guard let once = try? SwiftyPing(host: dest, configuration: config, queue: queue) else {
            os_log("failed to create SwiftyPing", log: self.log, type: .error)
            return .infinity
        }

        let group = DispatchGroup()
        group.enter()

        var latency: Double = 0.0
        once.observer = { response in
            latency = response.duration
            group.leave()
        }
        once.targetCount = 1
        do {
            try once.startPinging()
        }
        catch {
            os_log("failed to start pinging", log: self.log, type: .error)
            once.observer = nil
            group.leave()
        }
        group.wait()

        return latency
    }
}
