//
//  Array+Extensions.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
         guard index >= startIndex, index < endIndex else { return nil }
         return self[index]
    }
}
