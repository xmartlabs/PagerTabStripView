//
//  NavBarItem.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarItem: View, Identifiable {
    @EnvironmentObject private var dataStore: DataStore
    @Binding private var selection: Int
    var id: Int

    public init(id: Int, selection: Binding<Int>) {
        self.id = id
        self._selection = selection
    }

    @MainActor var body: some View {
        if let dataItem = dataStore.items[id] {
            VStack {
                Button(action: {
                    let newIndex = dataItem.index
                    selection = newIndex
                }, label: {
                    dataStore.items[id]?.view
                })
                .buttonStyle(.plain)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                    dataItem.tabViewDelegate?.setState(state: pressing ? .highlighted : (dataItem.index == selection ? .selected : .normal))
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
