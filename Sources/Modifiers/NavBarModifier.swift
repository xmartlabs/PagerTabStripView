//
//  NavBarModifier.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

internal struct NavBarModifier: ViewModifier {
    @EnvironmentObject var pagerSettings: PagerSettings
    @Binding private var indexSelected: Int
    @Binding private var itemCount: Int
    private var navBarItemWidth: CGFloat {
        let totalItemWidth = (pagerSettings.width - (pagerSettings.tabItemSpacing * CGFloat(itemCount - 1)))
        return totalItemWidth / CGFloat(itemCount)
    }

    public init(itemCount: Binding<Int>, selection: Binding<Int>) {
        self._indexSelected = selection
        self._itemCount = itemCount
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: pagerSettings.tabItemSpacing) {
                if itemCount > 0 && pagerSettings.width > 0 {
                    ForEach(0...itemCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $indexSelected)
                            .frame(height: pagerSettings.tabItemHeight)
                    }
                }
            }
            .frame(height: pagerSettings.tabItemHeight)
            HStack {
                if let width = navBarItemWidth, width > 0, width <= pagerSettings.width {
                    let x = -self.pagerSettings.contentOffset / CGFloat(itemCount) + width / 2
                    Rectangle()
                        .fill(pagerSettings.indicatorBarColor)
                        .animation(.default)
                        .frame(width: width)
                        .position(x: x, y: 0)
                }
            }
            .frame(height: pagerSettings.indicatorBarHeight)
            content
        }
    }
}

internal extension GeometryReader {
    func navBar(itemCount: Binding<Int>, selection: Binding<Int>) -> some View {
        return self.modifier(NavBarModifier(itemCount: itemCount, selection: selection))
    }
}
