//
//  SegmentedNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct SegmentedNavBarView<SelectionType>: View where SelectionType: Hashable {
    @Binding private var selection: SelectionType
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? SegmentedControlStyle {
            Picker("SegmentedNavBarView", selection: $selection) {
                if pagerSettings.items.count > 0 && pagerSettings.width > 0 {
                    ForEach(pagerSettings.itemsOrderedByIndex, id: \.self) { tag in
                        if let dataItem = pagerSettings.items[tag] {
                            NavBarItem(id: tag, selection: $selection)
                                .tag(tag)
                                .id(dataItem.id)
                        } else {
                            NavBarItem(id: tag, selection: $selection)
                                .tag(tag)
                        }
                    }
                }
            }
            .pickerStyle(.segmented)
            .colorMultiply(internalStyle.backgroundColor)
            .padding(internalStyle.padding)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
