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
                VStack {
                    HStack(spacing: style.tabItemSpacing) {
                        if dataStore.itemsCount > 0 {
                            ForEach(0...dataStore.itemsCount-1, id: \.self) { idx in
                                NavBarItem(id: idx, selection: $selection)
                            }
                        }
                    }
                    IndicatorScrollableBarView(selection: $selection)
                }
                .frame(height: self.style.tabItemHeight)
            }
            .onChange(of: self.selection) { newSelection in
                withAnimation {
                    value.scrollTo(newSelection, anchor: .center)
                }
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}

internal struct IndicatorScrollableBarView: View {
    @EnvironmentObject private var dataStore: DataStore
    @Binding private var selection: Int
    @State private var position: Double = 0
    @State private var selectedItemWidth: Double = 0

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    var body: some View {
        HStack {
            Rectangle()
                .fill(style.indicatorBarColor)
                .animation(.default)
                .frame(width: selectedItemWidth)
                .position(x: position, y: 0)
            }
            .frame(height: style.indicatorBarHeight)
            .onChange(of: dataStore.widthUpdated) { updated in
                if updated {
                    let items = dataStore.items.filter { index, value in
                        index < selection
                    }
                    selectedItemWidth = dataStore.items[selection]?.itemWidth ?? 0
                    position = items.map({return $0.value.itemWidth ?? 0}).reduce(0, +) + (style.tabItemSpacing * CGFloat(selection)) + selectedItemWidth/2
                }
            }
            .onChange(of: settings.contentOffset) { newValue in
                let offset = newValue + (settings.width * CGFloat(selection))
                let percentage = offset / settings.width
                let items = dataStore.items.filter { index, value in
                    index < selection
                }

                let spaces = style.tabItemSpacing * CGFloat(selection-1)
                let actualWidth = dataStore.items[selection]?.itemWidth ?? 0
                var lastPosition = items.map({return $0.value.itemWidth ?? 0}).reduce(0, +)
                lastPosition += spaces + actualWidth/2
                var nextPosition = items.map({return $0.value.itemWidth ?? 0}).reduce(0, +)
                if percentage == 0 {
                    selectedItemWidth = dataStore.items[selection]?.itemWidth ?? 0
                    position = items.map({return $0.value.itemWidth ?? 0}).reduce(0, +) + style.tabItemSpacing * CGFloat(selection) + selectedItemWidth/2
                } else {
                    if percentage < 0 {
                        nextPosition += actualWidth + style.tabItemSpacing * CGFloat(selection+1)
                        nextPosition += ((dataStore.items[selection + 1])?.itemWidth ?? 0)/2
                    } else {
                        nextPosition += style.tabItemSpacing * CGFloat(selection-1)
                        nextPosition -= ((dataStore.items[selection - 1])?.itemWidth ?? 0)/2
                    }
                    position = lastPosition + (nextPosition - lastPosition)*abs(percentage)

                    if let selectedWidth = dataStore.items[selection]?.itemWidth, let nextWidth = percentage > 0 ? dataStore.items[selection-1]?.itemWidth : dataStore.items[selection+1]?.itemWidth, abs(percentage)>0 {
                        selectedItemWidth = selectedWidth - (selectedWidth-nextWidth)*abs(percentage)
                    }
                }

            }
            .onChange(of: selection) { newValue in
                let items = dataStore.items.filter { index, value in
                    index < newValue
                }
                selectedItemWidth = dataStore.items[newValue]?.itemWidth ?? 0
                position = items.map({return $0.value.itemWidth ?? 0}).reduce(0, +) + (style.tabItemSpacing * CGFloat(newValue)) + selectedItemWidth/2
            }
        }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}

