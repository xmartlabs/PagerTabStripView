//
//  ScrollableNavBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 23/8/21.
//

import Foundation
import SwiftUI

internal struct ScrollableNavBarView: View {
    @Binding private var selection: Int {
        mutating willSet {
            previousSelection = selection
        }
    }
    private var previousSelection: Int
    @EnvironmentObject private var dataStore: DataStore

    public init(selection: Binding<Int>) {
        self._selection = selection
        self.previousSelection = selection.wrappedValue
    }

    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: style.tabItemSpacing) {
                    if dataStore.itemsCount > 0 && settings.width > 0 {
                        ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                            VStack{
                                NavBarItem(id: idx, selection: $selection)
                                    .frame(height: self.style.tabItemHeight)
                            }
                        }
                    }
                }
            }.onChange(of: self.selection) { _ in
                withAnimation {
                    value.scrollTo(selection > previousSelection ? selection + 1 : selection - 1)
                }
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
