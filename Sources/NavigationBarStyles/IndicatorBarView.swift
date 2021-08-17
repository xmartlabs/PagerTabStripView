//
//  IndicatorBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 11/8/21.
//

import Foundation
import SwiftUI


internal struct IndicatorBarView: View {
    @EnvironmentObject private var dataStore: DataStore

    var body: some View {
        HStack {
            let totalItemWidth = (settings.width - (style.tabItemSpacing * CGFloat(dataStore.itemsCount - 1)))
            let navBarItemWidth = totalItemWidth / CGFloat(dataStore.itemsCount)
            if let width = navBarItemWidth, width > 0, width <= settings.width {
                let x = -settings.contentOffset / CGFloat(dataStore.itemsCount) + width / 2
                Rectangle()
                    .fill(style.indicatorBarColor)
                    .animation(.default)
                    .frame(width: width)
                    .position(x: x, y: 0)
            }
        }
        .frame(height: style.indicatorBarHeight)
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
