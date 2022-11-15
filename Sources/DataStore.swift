//
//  DataStore.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import Combine

class DataItem<SelectedType>: Identifiable where SelectedType: Hashable {
//    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
//        guard lhs.tag == rhs.tag && lhs.index == rhs.index && lhs.itemWidth == rhs.itemWidth else {
//            return false
//        }
//        return true
//    }
    var id: Int {
        tag.hashValue
    }
    private(set) var tag: SelectedType
    fileprivate(set) var view: AnyView? {
        didSet {
            tabViewDelegate = view as? PagerTabViewDelegate
        }
    }
    private(set) var tabViewDelegate: PagerTabViewDelegate?
    fileprivate(set) var itemWidth: Double?
    fileprivate(set) var index: Int

    fileprivate init(tag: SelectedType, index: Int, view: AnyView, itemWidth: Double? = nil) {
        self.tag = tag
        self.index = index
        self.view = view
        self.itemWidth = itemWidth
    }
}


class DataStore<SelectionType>: ObservableObject where SelectionType: Hashable {
    
    

    @Published private(set) var items = [SelectionType: DataItem<SelectionType>]() {
        didSet {
            itemsOrderedByIndex = items.values.sorted { $0.index < $1.index }.map {$0.tag }
            itemsCount = items.count
        }
    }

    @Published private(set) var itemsOrderedByIndex = [SelectionType]()
    @Published private(set) var itemsCount: Int = 0
    @Published fileprivate(set) var widthUpdated: Bool = false
    
    func createOrUpdate(tag: SelectionType, index: Int, view: AnyView) {
        if let dataItem = items[tag] {
            dataItem.index = index
            dataItem.view = view
            items[tag] = dataItem
        } else {
            items[tag] = DataItem(tag: tag, index: index, view: view)
        }
    }

    func update(tag: SelectionType, itemWidth: Double) {
        if let dataItem = items[tag], dataItem.itemWidth != itemWidth, itemWidth > 0 {
            dataItem.itemWidth = itemWidth
            items[tag] = dataItem
        }
        widthUpdated = items.count > 0 && items.filter({ $0.value.itemWidth ?? 0 > 0 }).count == items.count
    }

    func remove(tag: SelectionType) {
        items[tag]?.tabViewDelegate?.setState(state: .normal)
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
}
