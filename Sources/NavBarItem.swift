//
//  NavBarItem.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarItem<SelectionType>: View, Identifiable where SelectionType: Hashable {
    @EnvironmentObject private var dataStore: DataStore<SelectionType>
    @Binding private var selection: SelectionType
    var id: SelectionType

    public init(id: SelectionType, selection: Binding<SelectionType>) {
        self.id = id
        self._selection = selection
    }

    @MainActor var body: some View {
        if let dataItem = dataStore.items[id] {
            VStack {
                Button(action: {
                    selection = id
                }, label: {
                    dataStore.items[id]?.view
                })
                .buttonStyle(.plain)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                    dataItem.tabViewDelegate?.setState(state: pressing ? .highlighted : (dataItem.tag == selection ? .selected : .normal))
                } perform: {}
            }.background(
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        dataStore.update(tag: id, itemWidth: Double(geometry.size.width))
                    }
                }
            )
        }
    }
}
