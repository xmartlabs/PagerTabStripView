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
            Button(action: {
                self.currentIndex = id
            }, label: {
                dataStore.items[id]?.view
            }).buttonStyle(PlainButtonStyle())
        }
    }
}
