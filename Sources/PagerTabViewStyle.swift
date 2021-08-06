//
//  PagerTabViewStyle.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

public struct PagerTabViewStyle {
    /// The space between navigation bar tab items.  This parameter is 0 by default.
    var tabItemSpacing: CGFloat
    /// The height of the navigation bar. This parameter is 50 by default.
    var tabItemHeight: CGFloat
    /// The height of the indicator bar. This parameter is 2 by default.
    var indicatorBarHeight: CGFloat
    /// The height of the indicator bar. This parameter is blue by default.
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
