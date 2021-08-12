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
    private var backgroundColor: Color?
    private var leading: CGFloat?
    private var trailing: CGFloat?

    public init(selection: Binding<Int>, backgroundColor: Color?, leading: CGFloat?, trailing: CGFloat?) {
        self._selection = selection
        self.backgroundColor = backgroundColor
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        Picker("SegmentedNavBarView", selection: $selection) {
            if dataStore.itemsCount > 0 && settings.width > 0 {
                ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                    NavBarItem(id: idx, selection: $selection)
                }
            }
        }
        .background(backgroundColor)
        .padding((EdgeInsets(top: 0, leading: leading ?? 0, bottom: 0, trailing: trailing ?? 0)))
        .pickerStyle(SegmentedPickerStyle())
    }

    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @EnvironmentObject private var settings: PagerSettings
}
