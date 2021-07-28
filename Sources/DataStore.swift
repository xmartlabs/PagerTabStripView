//
//  DataStore.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Combine
import SwiftUI

class DataItem {
    var view: AnyView?
    var tabViewDelegate: PagerTabViewDelegate?
    var appearCallback: (() -> Void)?

    init(view: AnyView?, tabViewDelegate: PagerTabViewDelegate? = nil, callback: (() -> Void)? = nil) {
        self.view = view
        self.appearCallback = callback
        self.tabViewDelegate = tabViewDelegate
    }
}

class DataStore: ObservableObject {
    @Published var items = [Int: DataItem]()

    func setView(_ view: AnyView, tabViewDelegate: PagerTabViewDelegate? = nil, at index: Int) {
        if let item = items[index] {
            item.view = view
            item.tabViewDelegate = tabViewDelegate
        } else {
            items[index] = DataItem(view: view, tabViewDelegate: tabViewDelegate)
        }
    }

    func setAppear(callback: @escaping () -> Void, at index: Int) {
        if let item = items[index] {
            item.appearCallback = callback
        } else {
            items[index] = DataItem(view: nil, callback: callback)
        }

    }

    func remove(at index: Int) {
        items[index] = nil
    }
}
