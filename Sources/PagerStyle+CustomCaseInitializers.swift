//
//  PagerStyle+CustomCaseInitializers.swift
//  PagerTabStripView
//
//  Created by Seyed Mojtaba Hosseini Zeidabadi on 3/11/22.
//

import SwiftUI

/// Case helper for crating generic cases and easier to use ViewBuilders
public extension PagerStyle {

    static func custom<Indicator: View, Background: View>(
        tabItemSpacing: CGFloat = 0,
        tabItemHeight: CGFloat = 60,
        placedInToolbar: Bool = false,
        @ViewBuilder indicator: @escaping () -> Indicator,
        @ViewBuilder background: @escaping () -> Background
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: {
                .init(indicator())
            },
            background: { .init(background()) }
        )
    }

    static func custom<Indicator: View>(
        tabItemSpacing: CGFloat = 0,
        tabItemHeight: CGFloat = 60,
        placedInToolbar: Bool = false,
        @ViewBuilder indicator: @escaping () -> Indicator
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: { .init(indicator()) },
            background: { .init(EmptyView()) }
        )
    }

    static func custom<Background: View>(
        tabItemSpacing: CGFloat = 0,
        tabItemHeight: CGFloat = 60,
        placedInToolbar: Bool = false,
        @ViewBuilder background: @escaping () -> Background
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: { .init(Rectangle()) },
            background: { .init(background()) }
        )
    }
}
