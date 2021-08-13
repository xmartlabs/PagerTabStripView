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
            switch self.style {
            case .bar:
                IndicatorBarView()
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            case .segmentedControl:
                SegmentedNavBarView(selection: $selection)
            case .normal:
                FixedSizeNavBarView(selection: $selection)
                IndicatorBarView()
            }
            content
        }
    }
    
    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
