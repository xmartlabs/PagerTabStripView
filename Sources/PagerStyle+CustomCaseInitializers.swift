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
    static let defaultPagerAnimation: Animation = .interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25)

    static func custom(
        tabItemSpacing: CGFloat = defaultTabItemSpacing,
        tabItemHeight: CGFloat = defaultTabItemHeight,
        placedInToolbar: Bool = false,
        @ViewBuilder indicator: @escaping () -> some View = { Rectangle() },
        @ViewBuilder background: @escaping () -> some View = { EmptyView() },
        pagerAnimation: Animation? = defaultPagerAnimation
    ) -> Self {
        .custom(
            tabItemSpacing: tabItemSpacing,
            tabItemHeight: tabItemHeight,
            placedInToolbar: placedInToolbar,
            indicator: { .init(indicator()) },
            background: { .init(background()) },
            pagerAnimation: pagerAnimation
        )
    }
}
