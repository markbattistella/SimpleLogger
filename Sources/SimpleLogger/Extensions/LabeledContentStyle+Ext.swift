//
// Project: 
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// A content style that arranges the label and content vertically.
///
/// `VerticalLabeledContentStyle` is used to display a label above its associated content
/// in a vertical stack, with the label styled in bold font and aligned to the leading edge.
///
/// This style is particularly useful for forms or settings screens where labels and content
/// are presented in a clear and distinct manner.
public struct VerticalLabeledContentStyle: LabeledContentStyle {
    
    /// Creates the body of a labeled content view for this style.
    ///
    /// - Parameter configuration: The properties of the labeled content view, including the
    /// label and the content to display.
    /// - Returns: A view that arranges the label and content in a vertical stack, with the
    /// label displayed in bold font above the content.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .fontWeight(.bold)
            configuration.content
        }
        .padding(.bottom, 4)
    }
}

extension LabeledContentStyle where Self == VerticalLabeledContentStyle {
    
    /// A static property that returns an instance of `VerticalLabeledContentStyle`.
    ///
    /// Use this property to apply the vertical style to a labeled content view, aligning
    /// the label above the content in a vertical stack.
    public static var vertical: VerticalLabeledContentStyle { Self() }
}
