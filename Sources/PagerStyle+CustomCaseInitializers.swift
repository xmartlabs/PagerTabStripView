//
//  PagerStyle+CustomCaseInitializers.swift
//  PagerTabStripView
//
//  Created by Seyed Mojtaba Hosseini Zeidabadi on 3/11/22.
//

import SwiftUI

/// Case helper for crating generic cases and easier to use ViewBuilders
public extension PagerStyle {

    static let defaultTabItemSpacing: CGFloat = 0
    static let defaultTabItemHeight: CGFloat = 60

    static func custom<Indicator: View, Background: View>(
        tabItemSpacing: CGFloat = defaultTabItemSpacing,
        tabItemHeight: CGFloat = defaultTabItemHeight,
        placedInToolbar: Bool = false,
        @ViewBuilder indicator: @escaping () -> Indicator,
        @ViewBuilder background: @escaping () -> Background
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: { .init(indicator()) },
            background: { .init(background()) }
        )
    }

    static func custom<Indicator: View>(
        tabItemSpacing: CGFloat = defaultTabItemSpacing,
        tabItemHeight: CGFloat = defaultTabItemHeight,
        placedInToolbar: Bool = false,
        @ViewBuilder indicator: @escaping () -> Indicator
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: indicator,
            background: { EmptyView() }
        )
    }

    static func custom<Background: View>(
        tabItemSpacing: CGFloat = defaultTabItemSpacing,
        tabItemHeight: CGFloat = defaultTabItemHeight,
        placedInToolbar: Bool = false,
        @ViewBuilder background: @escaping () -> Background
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: { Rectangle() },
            background: background
        )
    }
}
