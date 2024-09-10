//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

/// A type alias for a platform-agnostic color class that provides a unified color type for
/// cross-platform development.

#if canImport(UIKit)

import UIKit.UIColor

/// `AgnosticColor` is defined as `UIColor` on platforms that can import UIKit, such as iOS, macOS
/// (via Mac Catalyst), tvOS, and watchOS. This type alias allows for consistent use of color
/// objects across multiple platforms using UIKit's color representation.
internal typealias AgnosticColor = UIColor

#else

import AppKit.NSColor

/// `AgnosticColor` is defined as `NSColor` on macOS, offering a unified approach for color
/// management in macOS applications. This type alias allows for consistent use of color objects
/// across platforms using AppKit's color representation.
internal typealias AgnosticColor = NSColor

#endif

extension AgnosticColor {
    
    /// A predefined cyan color represented as an `AgnosticColor` with specific RGB values.
    ///
    /// This color provides a consistent cyan shade across different platforms using the
    /// `AgnosticColor` type alias.
    ///
    /// - Returns: An `AgnosticColor` instance representing the cyan color with the specified 
    /// RGB values.
    internal static let predatedCyan: AgnosticColor = .init(
        red: 50/255, green: 173/255, blue: 230/255, alpha: 1)
}
