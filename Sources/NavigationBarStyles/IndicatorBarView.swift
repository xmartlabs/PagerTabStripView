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
                    .onChange(of: pagerSettings.width) { width in
                        guard pagerSettings.items.count > 0, width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = width - (internalStyle.tabItemSpacing * CGFloat(pagerSettings.items.count - 1))
                        indicatorWidth =  totalItemWidth / CGFloat(pagerSettings.items.count)
                        x = (-pagerSettings.contentOffset / CGFloat(pagerSettings.items.count)) + (indicatorWidth / 2)
                    }
                    .onChange(of: pagerSettings.contentOffset) { _ in
                        guard pagerSettings.items.count > 0, pagerSettings.width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = pagerSettings.width - (internalStyle.tabItemSpacing * CGFloat(pagerSettings.items.count - 1))
                        indicatorWidth = totalItemWidth / CGFloat(pagerSettings.items.count)
                        x = (-pagerSettings.contentOffset / CGFloat(pagerSettings.items.count)) + (indicatorWidth / 2)
                    }
                    .onChange(of: pagerSettings.itemsOrderedByIndex) { items in
                        guard items.count > 0, pagerSettings.width > 0 else {
                            indicatorWidth = 0
                            x = 0
                            return
                        }
                        let totalItemWidth = pagerSettings.width - (internalStyle.tabItemSpacing * CGFloat(pagerSettings.items.count - 1))
                        indicatorWidth = totalItemWidth / CGFloat(pagerSettings.items.count)
                        x = (-pagerSettings.contentOffset / CGFloat(pagerSettings.items.count)) + (indicatorWidth / 2)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            appeared = true
                        }
                    }
                    .onDisappear {
                        appeared = false
                    }
            }
            .frame(height: internalStyle.indicatorViewHeight)
        }
    }

    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
}
