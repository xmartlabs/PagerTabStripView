//
//  Bool+Extension.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 14/4/21.
//

import Foundation

extension Bool {
    static var iOS13: Bool {
        guard #available(iOS 14, *) else {
            // It's iOS 13 so return true.
            return true
        }
        // It's iOS 14 so return false.
        return false
    }
}
