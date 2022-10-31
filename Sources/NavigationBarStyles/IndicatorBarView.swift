//
//  IndicatorBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct IndicatorBarView<Indicator>: View where Indicator: View {
    @EnvironmentObject private var dataStore: DataStore
    @ViewBuilder var indicator: () -> Indicator

    var body: some View {
        if let internalStyle = style as? PagerWithIndicatorStyle {
            HStack {
                let totalItemWidth = (settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.itemsCount - 1)))
                let navBarItemWidth = totalItemWidth / CGFloat(dataStore.itemsCount)
                if let navBarItemWidth, navBarItemWidth > 0, navBarItemWidth <= settings.width {
                    let x = -settings.contentOffset / CGFloat(dataStore.itemsCount) + navBarItemWidth / 2
                    indicator()
                        .animation(.default)
                        .frame(width: navBarItemWidth)
                        .position(x: x, y: internalStyle.indicatorViewHeight / 2)
                }
            }
            .frame(height: internalStyle.indicatorViewHeight)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
