//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Commerce and Purchases

extension LoggerCategory {

    /// Logger category for in-app purchase-related logs.
    public static let iap = LoggerCategory("IAP")

    /// Logger category for subscription-related logs.
    public static let subscriptions = LoggerCategory("Subscriptions")

    /// Logger category for receipt-related logs.
    public static let receipts = LoggerCategory("Receipts")
}
