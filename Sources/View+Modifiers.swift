//
//  Extensions.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

extension View {

/// Sets the navigation bar item associated with this page.
///
/// - Parameter pagerTabView: The navigation bar item to associate with this page.
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View {
        return self.modifier(PagerTabItemModifier(navTabView: pagerTabView))
    }

/// Adds an action to perform when the user switches to this page, either by scrolling to it or tapping its tab.
/// This modifier is applied to a specific page.
///
/// - Parameter action: The action to perform.
///
/// - Returns: A view that triggers `action` when this view appears.
    public func onPageAppear(perform action: (() -> Void)?) -> some View {
        return self.modifier(PagerSetAppearItemModifier(onPageAppear: action ?? {}))
    }

/// Sets the style for the pager view within the the current environment.
///
/// - Parameter style: The style to apply to this pager view.
    public func pagerTabStripViewStyle(_ style: PagerStyle) -> some View {
        return self.environment(\.pagerStyle, style)
    }
}
