//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A labeled content style that arranges the label above its content.
///
/// `VerticalLabeledContentStyle` is useful for displaying key–value pairs where the value may
/// span multiple lines or require more horizontal space than the default horizontal layout
/// allows.
internal struct VerticalLabeledContentStyle: LabeledContentStyle {
    
    /// Creates the styled view for a labeled content instance.
    ///
    /// - Parameter configuration: The label and content views provided by the `LabeledContent`
    /// instance.
    /// - Returns: A vertically stacked representation of the label and content.
    internal func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .fontWeight(.bold)
            
            configuration.content
        }
        .padding(.bottom, 6)
    }
}

extension LabeledContentStyle where Self == VerticalLabeledContentStyle {
    
    /// A vertical labeled content style with the label displayed above the content.
    ///
    /// Use this style by applying `.labeledContentStyle(.vertical)` to a view hierarchy
    /// containing `LabeledContent`.
    internal static var vertical: VerticalLabeledContentStyle {
        Self()
    }
}
