//
//  Extensions.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

extension View {

/// Sets the navigation bar item associated with this page.
///
/// - Parameter pagerTabView: The navigation bar item to associate with this page.
    public func pagerTabItem(tag: Int, @ViewBuilder _ pagerTabView: @escaping () -> some View) -> some View {
        return self.modifier(PagerTabItemModifier(tag: tag, navTabView: pagerTabView))
    }

    /// Sets the style for the pager view within the the current environment.
    ///
    /// - Parameter style: The style to apply to this pager view.
    public func pagerTabStripViewStyle(_ style: PagerStyle) -> some View {
        return self.environment(\.pagerStyle, style)
    }
}
