//
//  PagerTabViewStyle.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI


@available (*, deprecated, message: "use PagerStyls instead")
public struct PagerTabViewStyle {
    /// The space between navigation bar tab items.  This parameter is 0 by default.
    var tabItemSpacing: CGFloat
    /// The height of the indicator bar. This parameter is 2 by default.
    var indicatorBarHeight: CGFloat
    /// The height of the indicator bar. This parameter is blue by default.
    var indicatorBarColor: Color


    public init(tabItemSpacing: CGFloat = 0, indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue) {
        self.tabItemSpacing = tabItemSpacing
        self.indicatorBarHeight = indicatorBarHeight
        self.indicatorBarColor = indicatorBarColor
    }
    
    public init(tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat, indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue){
        self.init(tabItemSpacing: tabItemSpacing, indicatorBarHeight: indicatorBarHeight, indicatorBarColor: indicatorBarColor)
    }
}

public enum PagerStyle {
    case segmentedControl(backgroundColor: Color = .white, padding: EdgeInsets = EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10), placedInToolbar: Bool = false)
    /// The height of the indicator bar
    case bar(indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue, tabItemSpacing: CGFloat = 0, placedInToolbar: Bool = false)
    /// The height of the indicator bar
    /// tabItemSpacing: The space between navigation bar tab items.
    case barButton(indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue, tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 60, placedInToolbar: Bool = false)

    case scrollableBarButton(indicatorBarHeight: CGFloat = 2, indicatorBarColor: Color = .blue, padding: EdgeInsets = EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10), tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 60, placedInToolbar: Bool = false)

    internal var tabItemSpacing: CGFloat {
        switch self {
        case .bar(_, _, let spacing, _):
            return spacing
        case .barButton(_, _, let spacing, _, _):
            return spacing
        case .scrollableBarButton(_, _, _, let spacing, _, _):
            return spacing
        default:
            return 0
        }
    }

    internal var indicatorBarColor: Color {
        switch self {
        case .bar(_, let color, _, _):
            return color
        case .barButton(_, let color, _, _, _):
            return color
        case .scrollableBarButton(_, let color, _, _, _, _):
            return color
        default:
            return Color.clear
        }
    }

    internal var indicatorBarHeight: CGFloat{
        switch self {
        case .bar(let height,_, _, _):
            return height
        case .barButton(let height, _, _, _, _):
            return height
        case .scrollableBarButton(let height, _, _, _, _, _):
            return height
        default:
            return 2
        }
    }

    internal var tabItemHeight: CGFloat {
        switch self {
        case .barButton(_, _, _, let height, _):
            return height
        case .scrollableBarButton(_, _, _, _, let height, _):
            return height
        default:
            return 0
        }
    }

    internal var backgroundColor: Color {
        switch self {
        case .segmentedControl(let backgroundColor, _, _):
            return backgroundColor
        default:
            return .white
        }
    }

    internal var padding: EdgeInsets {
        switch self {
        case .segmentedControl(_, let padding, _):
            return padding
        case .scrollableBarButton(_, _, let padding, _, _, _):
            return padding
        default:
            return EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)
        }
    }

    internal var placedInToolbar: Bool {
        switch self {
        case .segmentedControl(_, _, let placedInToolbar):
            return placedInToolbar
        case .bar( _, _, _, let placedInToolbar):
            return placedInToolbar
        case .barButton( _, _, _, _, let placedInToolbar):
            return placedInToolbar
        case .scrollableBarButton( _, _, _, _, _, let placedInToolbar):
            return placedInToolbar
        }
    }
}

private struct PagerStyleKey: EnvironmentKey {
    static let defaultValue = PagerStyle.barButton()
}

extension EnvironmentValues {
    var pagerStyle: PagerStyle {
        get { self[PagerStyleKey.self] }
        set { self[PagerStyleKey.self] = newValue }
    }
}
