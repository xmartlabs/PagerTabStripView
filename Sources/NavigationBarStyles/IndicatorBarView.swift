//
//  IndicatorBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct IndicatorBarView<SelectionType, Indicator>: View where SelectionType: Hashable, Indicator: View {
    @EnvironmentObject private var dataStore: DataStore<SelectionType>
    @ViewBuilder var indicator: () -> Indicator

    var body: some View {
        if let internalStyle = style as? PagerWithIndicatorStyle {
            HStack {
                let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.itemsCount - 1))
                let navBarItemWidth = totalItemWidth / CGFloat(dataStore.items.count)
                if let navBarItemWidth, navBarItemWidth > 0, navBarItemWidth <= settings.width {
                    //let _ = print("content Offset \(settings.contentOffset), itemsCount \(dataStore.items.count), selection: \(dataStore.selection)")
                    let x = -settings.contentOffset / CGFloat(dataStore.items.count) + navBarItemWidth / 2
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
