//
//  NavBarItem.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

internal struct NavBarItem: View {
    @EnvironmentObject var navContentViews: DataStore
    @Binding private var currentIndex: Int
    private var id: Int

    public init(id: Int, selection: Binding<Int>) {
        self._currentIndex = selection
        self.id = id
    }

    var body: some View {
        if id < navContentViews.items.value.keys.count {
            Button(action: {
                self.currentIndex = id
            }, label: {
                navContentViews.items.value[id]?.view
            }).buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                navContentViews.items.value[id]?.tabViewDelegate?.setState(state: pressing ? .highlighted : .selected)
            } perform: {}
        }
    }
}
