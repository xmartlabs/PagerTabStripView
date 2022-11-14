//
//  SegmentedNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct SegmentedNavBarView: View {
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? SegmentedControlStyle {
            Picker("SegmentedNavBarView", selection: $selection) {
                if dataStore.itemsCount > 0 && settings.width > 0 {
                    ForEach(dataStore.itemsOrderedByIndex) { item in
                        NavBarItem(id: item.id, selection: $selection)
                            .tag(item.index)
                    }
                }
            }
            .pickerStyle(.segmented)
            .colorMultiply(internalStyle.backgroundColor)
            .padding(internalStyle.padding)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
