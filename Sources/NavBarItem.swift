//
//  NavBarItem.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarItem<SelectionType>: View, Identifiable where SelectionType: Hashable {

    var id: SelectionType
    @Binding private var selection: SelectionType
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>

    public init(id: SelectionType, selection: Binding<SelectionType>) {
        self.id = id
        self._selection = selection
    }

    @MainActor var body: some View {
        if let dataItem = pagerSettings.items[id] {
            dataItem.view
                .onTapGesture {
                    selection = id
                }
                .accessibilityAddTraits(id == selection ? .isSelected : [])
        }
    }
}
