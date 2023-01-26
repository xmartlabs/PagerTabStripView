//
//  pagerSettings.swift
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

public enum TransitionProgress<SelectionType: Hashable>: Equatable {
    case none
    case transition(from: SelectionType?, to: SelectionType?, percentage: Double)
    
    fileprivate init(from: SelectionType?, to: SelectionType?, percentage: Double){
        if from == nil && to == nil {
            self = .none
        }
        self = .transition(from: from, to: to, percentage: percentage)
    }

    public static func == (lhs: TransitionProgress<SelectionType>, rhs: TransitionProgress<SelectionType>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .transition),
            (.transition, .none):
            return false
        case (.none, .none):
            return true
        case (.transition(let from, let to, let percentage), .transition(let from2, let to2, let percentage2)):
            guard percentage == percentage2 else { return false }
            switch (from, from2) {
            case (.some, .none), (.none, .some):
                return false
            case (.some(let lhs), .some(let rhs)):
                guard  lhs == rhs else { return false }
            case (.none, .none):
                break
            }
            switch (to, to2) {
            case (.some, .none), (.none, .some):
                return false
            case (.some(let lhs), .some(let rhs)):
                guard  lhs == rhs else { return false }
            case (.none, .none):
                break
            }
        }
        return true
    }

    private var percetage: Double {
        switch self {
        case .none:
            return 0
        case .transition(_, _, let percentage):
            return percentage
        }
    }

    private var fromSelection: SelectionType? {
        switch self {
        case .none:
            return nil
        case .transition(let from, _, _):
            return from
        }
    }

    private var toSelection: SelectionType? {
        switch self {
        case .none:
            return nil
        case .transition(_, let to, _):
            return to
        }
    }

    public func progress(for tag: SelectionType) -> Double {
        if let fromSelection, fromSelection == tag {
            return 1 - percetage
        } else if let toSelection, toSelection == tag {
            return percetage
        }
        return 0
    }
}

public class PagerSettings<SelectionType>: ObservableObject where SelectionType: Hashable {

        @Published var width: CGFloat = 0 {
            didSet {
                recalculateTransition()
            }
        }

        @Published var contentOffset: CGFloat = 0 {
            didSet {
                recalculateTransition()
            }
        }

        @Published private(set) public var transition = TransitionProgress<SelectionType>.none

        @Published private(set) var items = [SelectionType: DataItem<SelectionType>]() {
            didSet {
                itemsOrderedByIndex = items.values.sorted { $0.index < $1.index }.map { $0.tag }
            }
        }
        @Published private(set) var itemsOrderedByIndex = [SelectionType]()

        private func recalculateTransition() {
            let indexAndPercentage = -contentOffset / width
            let percentage = (indexAndPercentage + 1).truncatingRemainder(dividingBy: 1)
            let lowIndex = Int(floor(indexAndPercentage))
            transition = TransitionProgress(from: itemsOrderedByIndex[safe: lowIndex], to: itemsOrderedByIndex[safe: lowIndex+1], percentage: percentage)
        }

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
