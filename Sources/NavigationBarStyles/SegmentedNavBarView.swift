//
//  SegmentedNavBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 11/8/21.
//

import Foundation
import SwiftUI

internal struct SegmentedNavBarView: View {
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore
    private var color: Color?
    private var padding: EdgeInsets

    public init(selection: Binding<Int>, color: Color?, padding: EdgeInsets) {
        self._selection = selection
        self.color = color
        self.padding = padding
    }

    var body: some View {
        Picker("SegmentedNavBarView", selection: $selection) {
            if dataStore.itemsCount > 0 && settings.width > 0 {
                ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                    NavBarItem(id: idx, selection: $selection)
                }
            }
        }
        .colorMultiply(color ?? .white)
        .pickerStyle(SegmentedPickerStyle())
        .padding(padding)
    }

    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
