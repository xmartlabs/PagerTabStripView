//
//  SegmentedNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
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
        Picker("SegmentedNavBarView", selection: $selection) {
            if dataStore.itemsCount > 0 && settings.width > 0 {
                ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                    NavBarItem(id: idx, selection: $selection)
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .colorMultiply(style.backgroundColor)
        .padding(style.padding)
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
