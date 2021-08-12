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
    /// The height of the indicator bar. This parameter is 2 by default.
    var indicatorBarHeight: CGFloat
    /// The height of the indicator bar. This parameter is blue by default.
    var indicatorBarColor: Color

    var pagerStyle: PagerStyles

    public init(tabItemSpacing: CGFloat = 0, indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue, style: PagerStyles = .normal()) {
        self.tabItemSpacing = tabItemSpacing
        self.indicatorBarHeight = indicatorBarHeight
        self.indicatorBarColor = indicatorBarColor
        self.pagerStyle = style
    }

    @available (*, deprecated, message: "It's only available in normal style. Set it in tabItemHeight")
    public init(tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat, indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue){
        self.init(tabItemSpacing: tabItemSpacing, indicatorBarHeight: indicatorBarHeight, indicatorBarColor: indicatorBarColor)
    }
}

public enum PagerStyles {
    case segmentedControl(backgroundColor: Color? = nil, leading: CGFloat = 10, trailing: CGFloat = 10)
    case bar
    case normal(tabItemHeight: CGFloat = 60)
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
