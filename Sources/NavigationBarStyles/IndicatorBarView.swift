//
//  IndicatorBarView.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct IndicatorBarView<Indicator: View>: View {
    @EnvironmentObject private var dataStore: DataStore

    @ViewBuilder var indicator: Indicator

    var body: some View {
        HStack {
            let totalItemWidth = (settings.width - (style.tabItemSpacing * CGFloat(dataStore.itemsCount - 1)))
            let navBarItemWidth = totalItemWidth / CGFloat(dataStore.itemsCount)
            if navBarItemWidth > 0, navBarItemWidth <= settings.width {
                let x = -settings.contentOffset / CGFloat(dataStore.itemsCount) + navBarItemWidth / 2

                indicator
                    .foregroundColor(style.indicatorBarColor)
                    .animation(.default)
                    .frame(width: navBarItemWidth)
                    .position(x: x, y: 0)
            }
        }
        .frame(height: style.indicatorBarHeight)
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
