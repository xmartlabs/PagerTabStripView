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
    @State private var indicatorWidth = CGFloat.zero
    @State private var x = CGFloat.zero
    @State private var appeared = false

    public init(selection: Binding<SelectionType>, indicator: @escaping () -> Indicator) {
        self._selection = selection
        self.indicator = indicator
    }

    var body: some View {
        if let internalStyle = style as? BarStyle {
            Group {
                indicator()
                    .frame(width: indicatorWidth, height: internalStyle.indicatorViewHeight)
                    .position(x: x, y: internalStyle.indicatorViewHeight / 2)
                    .animation(appeared ? .default : .none, value: x)
                    .onChange(of: settings.width) { width in
                        guard dataStore.items.count > 0, width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                        indicatorWidth =  totalItemWidth / CGFloat(dataStore.items.count)
                        x = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (indicatorWidth / 2)
                    }
                    .onChange(of: settings.contentOffset) { _ in
                        guard dataStore.items.count > 0, settings.width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                        indicatorWidth = totalItemWidth / CGFloat(dataStore.items.count)
                        x = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (indicatorWidth / 2)
                    }
                    .onChange(of: dataStore.itemsOrderedByIndex) { items in
                        guard items.count > 0, settings.width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = settings.width - (internalStyle.tabItemSpacing * CGFloat(dataStore.items.count - 1))
                        indicatorWidth = totalItemWidth / CGFloat(dataStore.items.count)
                        x = (-settings.contentOffset / CGFloat(dataStore.items.count)) + (indicatorWidth / 2)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            appeared = true
                        }
                    }
            }
            .frame(height: internalStyle.indicatorViewHeight)
        }
    }

    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
    @EnvironmentObject private var dataStore: DataStore<SelectionType>
}
