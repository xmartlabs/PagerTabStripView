//
//  NavBarItem.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarItem: View {
    @EnvironmentObject private var dataStore: DataStore
    @Binding private var currentIndex: Int
    private var id: Int

    public init(id: Int, selection: Binding<Int>) {
        self._currentIndex = selection
        self.id = id
    }

    var body: some View {
        if id < dataStore.itemsCount {
            VStack {
                Button(action: {
                    self.currentIndex = id
                }, label: {
                    dataStore.items[id]?.view
                }).buttonStyle(PlainButtonStyle())
            }.background(
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        dataStore.items[id]?.itemWidth = geometry.size.width
                        dataStore.widthUpdated = dataStore.itemsCount > 0 && dataStore.items.filter({ $0.value.itemWidth ?? 0 > 0 }).count == dataStore.itemsCount
                    }
                }
            )
        }
    }
}
