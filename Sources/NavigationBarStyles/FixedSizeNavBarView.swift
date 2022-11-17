//
//  FixedSizeNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct FixedSizeNavBarView<SelectionType, BG>: View where SelectionType: Hashable, BG: View {

    @Binding private var selection: SelectionType
    private var backgroundView: BG

    public init(selection: Binding<SelectionType>, background: () -> BG) {
        self._selection = selection
        self.backgroundView = background()
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            HStack(spacing: internalStyle.tabItemSpacing) {
                ForEach(dataStore.itemsOrderedByIndex, id: \.self) { tag in
                    NavBarItem(id: tag, selection: $selection)
                        .frame(height: internalStyle.tabItemHeight)
                        .tag(tag)
                }
            }
            .frame(height: internalStyle.tabItemHeight)
            .background(backgroundView)
        }
    }
    
    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var dataStore: DataStore<SelectionType>

    @EnvironmentObject private var settings: PagerSettings
}
