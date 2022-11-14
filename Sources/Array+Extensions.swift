//
//  Array+Extensions.swift
//  PagerTabStripView
//
//  Created by Martin Barreto on 11/11/22.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
         guard index >= startIndex, index < endIndex else {
             return nil
         }
         return self[index]
    }
}
