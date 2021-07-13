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
    var items = CurrentValueSubject<[Int: DataItem], Never>([:])

    func setView(_ view: AnyView, tabViewDelegate: PagerTabViewDelegate? = nil, at index: Int) {
        if let item = items.value[index] {
            item.view = view
            item.tabViewDelegate = tabViewDelegate
        } else {
            items.value[index] = DataItem(view: view, tabViewDelegate: tabViewDelegate)
        }
    }

    func setAppear(callback: @escaping () -> Void, at index: Int) {
        if let item = items.value[index] {
            item.appearCallback = callback
        } else {
            items.value[index] = DataItem(view: nil, callback: callback)
        }

    }

    func remove(at index: Int) {
        items.value[index] = nil
    }
}
