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
                .onChange(of: dataStore.widthUpdated) { _ in
                    guard switchAppeared, let selectedItem = dataStore.items[selection] else { return }
                    // This is necessary because anchor: .center is not working correctly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let tags = dataStore.itemsOrderedByIndex
                        var remainingItemsWidth = (selectedItem.itemWidth ?? 0) / 2
                        let remaininigItems = tags[(selectedItem.index + 1)...].map { dataStore.items[$0] }
                        remainingItemsWidth += remaininigItems.map { $0?.itemWidth ?? 0}.reduce(0, +)
                        remainingItemsWidth += CGFloat(dataStore.items.count-1 - selectedItem.index) * internalStyle.tabItemSpacing
                        let centerSel = remainingItemsWidth > (settings.width / 2)
                        value.scrollTo(centerSel ? selection : tags.last, anchor: centerSel ? .center : nil)
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
                .animation(.default, value: appeared)
                .frame(width: selectedItemWidth)
                .position(x: position)
                .onAppear {
                    appeared = true
                }
                .onChange(of: dataStore.widthUpdated) { updated in
                    if updated, let selectedItem = dataStore.items[selection] {
                        let tags = dataStore.itemsOrderedByIndex
                        let tagsBeforeSelected = tags[..<selectedItem.index]
                        selectedItemWidth = selectedItem.itemWidth ?? 0
                        var newPosition = tagsBeforeSelected.map { dataStore.items[$0]?.itemWidth ?? 0 }.reduce(0, +)
                        newPosition += (internalStyle.tabItemSpacing * CGFloat(selectedItem.index)) + selectedItemWidth/2
                        position = newPosition
                    }
                }
                .onChange(of: settings.contentOffset) { newValue in
                    print("contentOffset: \(newValue)")
                    guard let selectedItem = dataStore.items[selection], dataStore.widthUpdated else { return } //,
                    let itemsCount = dataStore.items.count
                    let itemsWidth = dataStore.itemsOrderedByIndex.map { dataStore.items[$0]?.itemWidth ?? 0}
                    let selectedWidth = selectedItem.itemWidth!
                    let selectedIndex = dataStore.indexOf(tag: selection)
                    let spaces = internalStyle.tabItemSpacing * CGFloat(selectedItem.index-1)
                    let offset = newValue + (settings.width * CGFloat(selectedIndex))
                    let percentage = offset / settings.width
                    print("---->percentage \(percentage)")
                    print("---->selectedIndex \(selectedIndex)")
                    let items = itemsWidth[0..<selectedIndex]
                    let lastPosition = items.reduce(0, +) + spaces + (selectedWidth/2)
                    var nextPosition = items.reduce(0, +)
                    if percentage == 0 {
                        withAnimation {
                            selectedItemWidth = itemsWidth[selectedIndex]
                            var newPosition = items.reduce(0, +) + (selectedItemWidth/2)
                            newPosition += (internalStyle.tabItemSpacing * CGFloat(selectedIndex))
                            position = newPosition
                        }
                    } else {
                        if percentage < 0 { // goes right
                            nextPosition += selectedWidth + internalStyle.tabItemSpacing * CGFloat(selectedIndex+1)
                            nextPosition += itemsWidth[min(selectedIndex + 1, itemsCount - 1)] / 2
                        } else if percentage > 0 { // goes left
                            nextPosition += internalStyle.tabItemSpacing * CGFloat(max(0, selectedIndex-1))
                            nextPosition -= itemsWidth[max(0, selectedIndex - 1)] / 2
                        }
                        let nextWidth = percentage > 0 ? itemsWidth[max(0, selectedIndex-1)] : itemsWidth[min(selectedIndex+1, itemsCount - 1)]
                        selectedItemWidth = itemsWidth[selectedIndex] - (itemsWidth[selectedIndex]-nextWidth)*abs(percentage)
                        position = lastPosition + ((nextPosition - lastPosition)*abs(percentage))
                    }
                }
                .onChange(of: selection) { newValue in
                    guard let newSelectedItem = dataStore.items[newValue], dataStore.widthUpdated else { return }
                    let navBarItems = dataStore.itemsOrderedByIndex
                    let items = navBarItems[0..<newSelectedItem.index]
                    withAnimation {
                        selectedItemWidth = newSelectedItem.itemWidth ?? 0
                        var newPosition = items.map { dataStore.items[$0]?.itemWidth ?? 0 }.reduce(0, +)
                        newPosition += (internalStyle.tabItemSpacing * CGFloat(newSelectedItem.index)) + (selectedItemWidth/2)
                        position = newPosition
                    }
                }
                .onReceive(dataStore.updatePublisher) { navBarItems in
                    guard dataStore.widthUpdated else { return }
                    guard let selectedItem = dataStore.items[selection] ?? dataStore.items[navBarItems.first!] else { return }
                    let selectedIndex = dataStore.indexOf(tag: selectedItem.tag)
                    let items = navBarItems[0..<selectedIndex]
                    let itemsWidth = items.map { dataStore.items[$0]?.itemWidth ?? 0 }
                    selectedItemWidth = selectedItem.itemWidth ?? 0
                    var newPosition = itemsWidth.reduce(0, +)
                    newPosition += (internalStyle.tabItemSpacing * CGFloat(selectedIndex)) + (selectedItemWidth/2)
                    position = newPosition
                }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
