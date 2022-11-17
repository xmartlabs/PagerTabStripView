//
//  IndicatorBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct IndicatorBarView<SelectionType, Indicator>: View where SelectionType: Hashable, Indicator: View {
    
    @ViewBuilder var indicator: () -> Indicator
    @Binding private var selection: SelectionType
    @State private var navBarItemWidth: Double = 0
    @State private var positionX: Double = 0
    @State private var tabsWidhtReady = false
    
    public init(selection: Binding<SelectionType>, indicator: @escaping () -> Indicator){
        self._selection = selection
        self.indicator = indicator
    }

    var body: some View {
        if let internalStyle = style as? PagerWithIndicatorStyle {
            HStack {
                if tabsWidhtReady || style is BarStyle {
                    indicator()
                        .animation(.default)
                        .frame(width: navBarItemWidth)
                        .position(x: positionX, y: internalStyle.indicatorViewHeight / 2)
                }
            }
            .frame(height: internalStyle.indicatorViewHeight)
            .onChange(of: settings.width) { width in
                let totalItemWidth = width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                navBarItemWidth = totalItemWidth / CGFloat(dataStore.items.count)
                positionX = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (navBarItemWidth / 2)
            }
            .onChange(of: settings.contentOffset) { offset in
                let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                navBarItemWidth = totalItemWidth / CGFloat(dataStore.items.count)
                positionX = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (navBarItemWidth / 2)
            }
            .onReceive(dataStore.updatePublisher){ items in
                if dataStore.widthUpdated || style is BarStyle {
                    let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                    navBarItemWidth = totalItemWidth / CGFloat(dataStore.items.count)
                    positionX = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (navBarItemWidth / 2)
                }
            }
            .onChange(of: dataStore.widthUpdated) { widhtUpdated in
                tabsWidhtReady = widhtUpdated
                if tabsWidhtReady {
                    let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                    navBarItemWidth = totalItemWidth / CGFloat(dataStore.items.count)
                    positionX = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (navBarItemWidth / 2)
                }
            }
        }
    }

    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
    @EnvironmentObject private var dataStore: DataStore<SelectionType>
}
