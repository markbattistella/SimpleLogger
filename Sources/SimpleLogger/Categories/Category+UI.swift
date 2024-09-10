//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - UI and User Interaction

extension LoggerCategory {

    /// Logger category for UI-related logs.
    public static let ui = LoggerCategory("UI")

    /// Logger category for gesture-related logs.
    public static let gestures = LoggerCategory("Gestures")

    /// Logger category for animation-related logs.
    public static let animations = LoggerCategory("Animations")

    /// Logger category for transition-related logs.
    public static let transitions = LoggerCategory("Transitions")

    /// Logger category for accessibility-related logs.
    public static let accessibility = LoggerCategory("Accessibility")

    /// Logger category for localization-related logs.
    public static let localization = LoggerCategory("Localization")

    /// Logger category for internationalization-related logs.
    public static let internationalization = LoggerCategory("Internationalization")

    /// Logger category for theming-related logs.
    public static let theming = LoggerCategory("Theming")

    /// Logger category for styling-related logs.
    public static let styling = LoggerCategory("Styling")

    /// Logger category for layout-related logs.
    public static let layout = LoggerCategory("Layout")

    /// Logger category for rendering-related logs.
    public static let rendering = LoggerCategory("Rendering")
}
