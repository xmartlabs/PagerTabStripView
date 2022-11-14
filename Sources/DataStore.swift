//
//  DataStore.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import Combine

class DataItem: Identifiable, Equatable {
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
        guard lhs.tag == rhs.tag && lhs.index == rhs.index && lhs.itemWidth == rhs.itemWidth else {
            return false
        }
        return true
    }
    var id: Int {
        tag
    }
    private(set) var tag: Int
    fileprivate(set) var view: AnyView? {
        didSet {
            tabViewDelegate = view as? PagerTabViewDelegate
        }
    }
    private(set) var tabViewDelegate: PagerTabViewDelegate?
    fileprivate(set) var index: Int
    fileprivate(set) var itemWidth: Double?
    fileprivate init(tag: Int, index: Int, view: AnyView, itemWidth: Double? = nil) {
        self.tag = tag
        self.index = index
        self.view = view
        self.itemWidth = itemWidth
    }
}

class DataStore: ObservableObject {

    @Published private(set) var items = [Int: DataItem]() {
        didSet {
            itemsOrderedByIndex = items.values.sorted { $0.index < $1.index }
            itemsCount = items.count
        }
    }

    @Published private(set) var itemsOrderedByIndex = [DataItem]()
    @Published private(set) var itemsCount: Int = 0
    @Published fileprivate(set) var widthUpdated: Bool = false

    func createOrUpdate(tag: Int, index: Int, view: AnyView) {
        if let dataItem = items[tag] {
            dataItem.index = index
            dataItem.view = view
            items[tag] = dataItem
        } else {
            items[tag] = DataItem(tag: tag, index: index, view: view)
        }
    }

    func update(tag: Int, itemWidth: Double) {
        if let dataItem = items[tag], dataItem.itemWidth != itemWidth, itemWidth > 0 {
            dataItem.itemWidth = itemWidth
            items[tag] = dataItem
        }
        widthUpdated = items.count > 0 && items.filter({ $0.value.itemWidth ?? 0 > 0 }).count == itemsCount
    }

    func remove(tag: Int) {
        items[tag]?.tabViewDelegate?.setState(state: .normal)
        items.removeValue(forKey: tag)
    }
}
