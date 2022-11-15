//
//  ScrollableNavBarView.swift
//  PagerTabStripView
//
//  Created by Cecilia Pirotto on 23/8/21.
//

import Foundation
import SwiftUI

internal struct ScrollableNavBarView<SelectionType>: View where SelectionType: Hashable {
    @Binding private var selection: SelectionType
    @State private var switchAppeared: Bool = false
    @EnvironmentObject private var dataStore: DataStore<SelectionType>

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack(spacing: internalStyle.tabItemSpacing) {
                            ForEach(dataStore.itemsOrderedByIndex, id: \.self) { tag in
                                NavBarItem(id: tag, selection: $selection)
                                    .tag(tag)
                            }
                        }
                        IndicatorScrollableBarView(selection: $selection)
                    }
                    .frame(height: internalStyle.tabItemHeight)
                }
                .padding(internalStyle.padding)
                .onChange(of: switchAppeared) { _ in
                    // This is necessary because anchor: .center is not working correctly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        let selectedItem = dataStore.items[selection]!
//                        let tags = dataStore.itemsOrderedByIndex
//                        var remainingItemsWidth = (selectedItem?.itemWidth ?? 0) / 2
//                        let remaininigItems = tags[(selectedItem + 1)...].map { dataStore.items[$0] }
//                        remainingItemsWidth += remaininigItems.map {$0.itemWidth ?? 0}.reduce(0, +)
//                        remainingItemsWidth += CGFloat(dataStore.itemsCount-1 - selectedItem.index)*internalStyle.tabItemSpacing
//                        let centerSel = remainingItemsWidth > (settings.width / 2)
//                        value.scrollTo(centerSel ? selection : tags.last, anchor: centerSel ? .center : nil)
                    }
                }
                .onChange(of: selection) { newSelection in
                    withAnimation {
                        if let _ = dataStore.items[newSelection] {
                            value.scrollTo(newSelection, anchor: .center)
                        }
                    }
                }
            }
            .onAppear {
                switchAppeared.toggle()
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}

internal struct IndicatorScrollableBarView<SelectionType>: View where SelectionType: Hashable {
    
    @EnvironmentObject private var dataStore: DataStore<SelectionType>
    @Binding private var selection: SelectionType
    @State private var position: Double = 0
    @State private var selectedItemWidth: Double = 0
    @State private var appeared: Bool = false

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            internalStyle.indicatorView()
                .frame(height: internalStyle.indicatorViewHeight)
//                .animation(.default, value: appeared)
                .frame(width: selectedItemWidth)
                .position(x: position)
//                .onAppear {
//                    appeared = true
//                }
                .onChange(of: dataStore.widthUpdated) { updated in
                    if updated {
//                        let selectedItem = dataStore.items[selection]!
//                        let tags = dataStore.itemsOrderedByIndex
//                        let tagsBeforeSelected = tags[..<selectedItem.index]
//                        selectedItemWidth = selectedItem.itemWidth!
//                        let newPosition = tagsBeforeSelected.map { dataStore.items[$0]?.itemWidth ?? 0}.reduce(0, +)
//                                            + (internalStyle.tabItemSpacing * CGFloat(selection))
//                                            + selectedItemWidth/2
//                        position = newPosition
                    }
                }
                .onChange(of: settings.contentOffset) { newValue in
                    guard dataStore.items.values.allSatisfy({ ($0.itemWidth ?? 0) > 0 }) else {
                        return
                    }
//                    let itemsCount = dataStore.items.count
//                    let iSelection = selection
//                    let itemsWidth = dataStore.itemsOrderedByIndex.map { $0.itemWidth! }
//                    let actualWidth = itemsWidth[iSelection]
//                    let spaces = internalStyle.tabItemSpacing * CGFloat(iSelection-1)
//                    let pageWidth = settings.width
//                    let offset = newValue + (pageWidth * CGFloat(iSelection))
//                    let percentage = offset / pageWidth
//                    let items = itemsWidth[0..<iSelection]
//                    let lastPosition = items.reduce(0, +) + spaces + (actualWidth/2)
//                    var nextPosition = items.reduce(0, +)
//                    if percentage == 0 {
//                        withAnimation {
//                            selectedItemWidth = itemsWidth[iSelection]
//                            var newPosition = items.reduce(0, +) + (selectedItemWidth/2)
//                            newPosition += (internalStyle.tabItemSpacing * CGFloat(iSelection))
//                            position = newPosition
//                        }
//                    } else {
//                        if percentage < 0 { // goes right
//                            nextPosition += actualWidth + internalStyle.tabItemSpacing * CGFloat(iSelection+1)
//                            nextPosition += itemsWidth[min(iSelection + 1, itemsCount - 1)] / 2
//                        } else if percentage > 0 { // goes left
//                            nextPosition += internalStyle.tabItemSpacing * CGFloat(max(0, iSelection-1))
//                            nextPosition -= itemsWidth[max(0, iSelection - 1)] / 2
//                        }
//                        position = lastPosition + (nextPosition - lastPosition)*abs(percentage)
//                        let nextWidth = percentage > 0 ? itemsWidth[max(0, iSelection-1)] : itemsWidth[min(iSelection+1, itemsCount - 1)]
//                        selectedItemWidth = itemsWidth[iSelection] - (itemsWidth[iSelection]-nextWidth)*abs(percentage)
//                    }
                }
                .onChange(of: selection) { newValue in
//                    let navBarItems = dataStore.itemsOrderedByIndex
//                    let items = navBarItems.filter { $0.index < newValue }
//                    withAnimation {
//                        selectedItemWidth = navBarItems[newValue].itemWidth ?? 0
//                        var newPosition = items.map { $0.itemWidth ?? 0}.reduce(0, +)
//                        newPosition += (internalStyle.tabItemSpacing * CGFloat(newValue)) + (selectedItemWidth/2)
//                        position = newPosition
//                    }
                }
                .onChange(of: dataStore.itemsOrderedByIndex) { navBarItems in
//                    let selectedItem = dataStore.items[selection]!
//                    let items = navBarItems[..<selectedItem.index]
//                    let itemsWidth = items.map { dataStore.items[$0]?.itemWidth ?? 0 }
//                    selectedItemWidth = selectedItem.itemWidth
//                    var newPosition = itemsWidth.reduce(0, +)
//                    newPosition += (internalStyle.tabItemSpacing * CGFloat(selection)) + (selectedItemWidth/2)
//                    position = newPosition
                }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
