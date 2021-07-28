//
//  NavBarModifier.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    
    @Binding private var selection: Int
    @StateObject private var dataStore: DataStore
    
    private var navBarItemWidth: CGFloat {
        let totalItemWidth = (settings.width - (style.tabItemSpacing * CGFloat(dataStore.itemsCount - 1)))
        return totalItemWidth / CGFloat(dataStore.itemsCount)
    }

    public init(dataStore: StateObject<DataStore>, selection: Binding<Int>) {
        self._selection = selection
        self._dataStore = dataStore
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: style.tabItemSpacing) {
                if dataStore.itemsCount > 0 && settings.width > 0 {
                    ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $selection)
                            .frame(height: style.tabItemHeight)
                    }
                }
            }
            .frame(height: style.tabItemHeight)
            HStack {
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
            content
        }
    }
    
    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
