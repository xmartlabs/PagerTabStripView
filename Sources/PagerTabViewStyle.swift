//
//  PagerTabViewStyle.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

public struct PagerTabViewStyle {
    var tabItemSpacing: CGFloat
    var tabItemHeight: CGFloat
    var indicatorBarHeight: CGFloat
    var indicatorBarColor: Color
    
    public init(tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 50, indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue){
        self.tabItemSpacing = tabItemSpacing
        self.tabItemHeight = tabItemHeight
        self.indicatorBarHeight = indicatorBarHeight
        self.indicatorBarColor = indicatorBarColor
    }
}

private struct PagerTabViewStyleKey: EnvironmentKey {
    static let defaultValue = PagerTabViewStyle()
}

extension EnvironmentValues {
    var pagerTabViewStyle: PagerTabViewStyle {
        get { self[PagerTabViewStyleKey.self] }
        set { self[PagerTabViewStyleKey.self] = newValue }
    }
}
