//
//  DataStore.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct DataItem<SelectedType>: Identifiable, Equatable where SelectedType: Hashable {
    
    static func == (lhs: DataItem<SelectedType>, rhs: DataItem<SelectedType>) -> Bool {
        return lhs.tag == rhs.tag
    }
    private(set) var tag: SelectedType
    fileprivate(set) var view: AnyView
    fileprivate(set) var index: Int
    
    var id: SelectedType { tag }

    fileprivate init(tag: SelectedType, index: Int, view: AnyView) {
        self.tag = tag
        self.index = index
        self.view = view
    }
}


class DataStore<SelectionType>: ObservableObject where SelectionType: Hashable {
    
    @Published private(set) var items = [SelectionType: DataItem<SelectionType>]() {
        didSet {
            itemsOrderedByIndex = items.values.sorted { $0.index < $1.index }.map { $0.tag }
        }
    }
    
    @Published private(set) var itemsOrderedByIndex = [SelectionType]()
    
    func createOrUpdate<TabView: View>(tag: SelectionType, index: Int, view: TabView) {
        if var dataItem = items[tag] {
            dataItem.index = index
            dataItem.view = AnyView(view)
            items[tag] = dataItem
        } else {
            items[tag] = DataItem(tag: tag, index: index, view: AnyView(view))
        }
    }

    func remove(tag: SelectionType) {
        items.removeValue(forKey: tag)
    }
    
    func nextSelection(for selection: SelectionType) -> SelectionType {
        guard let selectionIndex = itemsOrderedByIndex.firstIndex(of: selection) else {
            return self.itemsOrderedByIndex.first!
        }
        return itemsOrderedByIndex[safe: selectionIndex + 1] ?? selection
    }
    
    func previousSelection(for selection: SelectionType) -> SelectionType {
        guard let selectionIndex = itemsOrderedByIndex.firstIndex(of: selection) else {
            return itemsOrderedByIndex.first!
        }
        return itemsOrderedByIndex[safe: selectionIndex - 1] ?? selection
    }
    
    func indexOf(tag: SelectionType) -> Int? {
        return itemsOrderedByIndex.firstIndex(of: tag)
    }
}
