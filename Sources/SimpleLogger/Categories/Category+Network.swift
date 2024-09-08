//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Networking and Connectivity

extension LoggerCategory {
    
    /// Logger category for network-related logs.
    public static let network = LoggerCategory("Network")
    
    /// Logger category for API-related logs.
    public static let api = LoggerCategory("API")
    
    /// Logger category for upload-related logs.
    public static let upload = LoggerCategory("Upload")
    
    /// Logger category for download-related logs.
    public static let download = LoggerCategory("Download")
    
    /// Logger category for synchronization-related logs.
    public static let sync = LoggerCategory("Sync")
    
    /// Logger category for connectivity-related logs.
    public static let connectivity = LoggerCategory("Connectivity")
    
    /// Logger category for reachability-related logs.
    public static let reachability = LoggerCategory("Reachability")
    
    /// Logger category for streaming-related logs.
    public static let streaming = LoggerCategory("Streaming")
    
    /// Logger category for Bluetooth-related logs.
    public static let bluetooth = LoggerCategory("Bluetooth")
}
