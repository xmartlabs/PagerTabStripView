//
//  NavBarModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            let pagerStyle = style.pagerStyle
            switch pagerStyle {
            case .bar:
                IndicatorBarView()
            case .segmentedControl(backgroundColor: let backgroundColor, leading: let leading, trailing: let trailing):
                SegmentedNavBarView(selection: $selection, backgroundColor: backgroundColor, leading: leading, trailing: trailing)
            case .normal(tabItemHeight: let tabItemHeight):
                FixedSizeNavBarView(selection: $selection, tabItemHeight: tabItemHeight)
                IndicatorBarView()
            }
            content
        }
    }
    
    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
