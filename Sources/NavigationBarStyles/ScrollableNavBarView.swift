//
//  ScrollableNavBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 23/8/21.
//

import Foundation
import SwiftUI

internal struct ScrollableNavBarView: View {
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    var body: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
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
                    value.scrollTo(selection)
                }
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
