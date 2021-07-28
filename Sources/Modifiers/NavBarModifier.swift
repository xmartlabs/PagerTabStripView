//
//  NavBarModifier.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

internal struct NavBarModifier: ViewModifier {
    
    @Binding private var selection: Int
    @Binding private var itemCount: Int
    
    private var navBarItemWidth: CGFloat {
        let totalItemWidth = (settings.width - (style.tabItemSpacing * CGFloat(itemCount - 1)))
        return totalItemWidth / CGFloat(itemCount)
    }

    public init(itemCount: Binding<Int>, selection: Binding<Int>) {
        self._selection = selection
        self._itemCount = itemCount
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: style.tabItemSpacing) {
                if itemCount > 0 && settings.width > 0 {
                    ForEach(0...itemCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $selection)
                            .frame(height: style.tabItemHeight)
                    }
                }
            }
            .frame(height: style.tabItemHeight)
            HStack {
                if let width = navBarItemWidth, width > 0, width <= settings.width {
                    let x = -settings.contentOffset / CGFloat(itemCount) + width / 2
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
    
    @Environment(\.customStyleValue) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
