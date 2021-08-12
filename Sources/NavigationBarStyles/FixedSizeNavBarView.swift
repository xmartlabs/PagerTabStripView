//
//  FixedSizeNavBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 11/8/21.
//

import Foundation
import SwiftUI

internal struct FixedSizeNavBarView: View {
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore
    private var tabItemHeight: CGFloat

    public init(selection: Binding<Int>, tabItemHeight: CGFloat) {
        self._selection = selection
        self.tabItemHeight = tabItemHeight
    }

    var body: some View {
        HStack(spacing: style.tabItemSpacing) {
            if dataStore.itemsCount > 0 && settings.width > 0 {
                ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                    NavBarItem(id: idx, selection: $selection)
                        .frame(height: tabItemHeight)
                }
            }
        }
        .frame(height: tabItemHeight)
    }

    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
