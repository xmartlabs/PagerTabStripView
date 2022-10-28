//
//  PagerTabViewStyle.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

public protocol PagerStyle {
    var placedInToolbar: Bool { get }
    var pagerAnimation: Animation { get }
}

public protocol PagerWithIndicatorStyle: PagerStyle {
    var barBackgroundView: () -> AnyView { get }
    var indicatorView: () -> AnyView { get }
    var tabItemSpacing: CGFloat { get }
    var indicatorViewHeight: CGFloat { get }
}

extension PagerStyle where Self == BarStyle {
    public static func bar(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, indicatorViewHeight: CGFloat = 10, indicatorView: @escaping () -> some View = { Rectangle() }) -> BarStyle {
        return BarStyle(placedInToolbar: placedInToolbar, pagerAnimation: pagerAnimation, indicatorViewHeight: indicatorViewHeight, indicatorView: { .init(indicatorView()) })
    }
}

extension PagerStyle where Self == SegmentedControlStyle {
    public static func segmentedControl(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, backgroundColor: Color = .white, padding: EdgeInsets = EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)) -> SegmentedControlStyle {
        return SegmentedControlStyle(placedInToolbar: placedInToolbar, pagerAnimation: pagerAnimation, backgroundColor: backgroundColor, padding: padding)
    }
}

extension PagerStyle where Self == BarButtonStyle {
    public static func scrollableBarButton(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 50, padding: EdgeInsets = EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10), indicatorViewHeight: CGFloat = 2, @ViewBuilder barBackgroundView: @escaping () -> some View = { EmptyView() }, @ViewBuilder indicatorView: @escaping () -> some View = { Rectangle().fill(.blue) }) -> BarButtonStyle {
        return BarButtonStyle(placedInToolbar: placedInToolbar, pagerAnimation: pagerAnimation, tabItemSpacing: tabItemSpacing, tabItemHeight: tabItemHeight, scrollable: true, padding: padding, indicatorViewHeight: indicatorViewHeight, barBackgroundView: { AnyView(barBackgroundView()) }, indicatorView: { AnyView(indicatorView()) })
    }

    public static func barButton(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 50, padding: EdgeInsets = EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10), indicatorViewHeight: CGFloat = 2, @ViewBuilder barBackgroundView: @escaping () -> some View = { EmptyView() }, @ViewBuilder indicatorView: @escaping () -> some View = { Rectangle().fill(.blue) }) -> BarButtonStyle {
        return BarButtonStyle(placedInToolbar: placedInToolbar, pagerAnimation: pagerAnimation, tabItemSpacing: tabItemSpacing, tabItemHeight: tabItemHeight, scrollable: false, padding: padding, indicatorViewHeight: indicatorViewHeight, barBackgroundView: { AnyView(barBackgroundView()) }, indicatorView: { AnyView(indicatorView()) })
    }
}

public struct SegmentedControlStyle: PagerStyle {
    public var placedInToolbar: Bool
    public var pagerAnimation: Animation
    public var backgroundColor: Color
    public var padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    public init(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, backgroundColor: Color = .white, padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
        self.backgroundColor = backgroundColor
        self.placedInToolbar = placedInToolbar
        self.padding = padding
        self.pagerAnimation = pagerAnimation
    }

}

public struct BarStyle: PagerWithIndicatorStyle {
    public var placedInToolbar: Bool
    public var pagerAnimation: Animation = .default
    public var tabItemSpacing: CGFloat = 0
    public var indicatorViewHeight: CGFloat

    @ViewBuilder public var barBackgroundView: () -> AnyView
    @ViewBuilder public var indicatorView: () -> AnyView

    public init(placedInToolbar: Bool, pagerAnimation: Animation = .default, indicatorViewHeight: CGFloat = 8, barBackgroundView: @escaping (() -> AnyView) = { AnyView(EmptyView()) }, indicatorView: @escaping (() -> AnyView) = { AnyView(Rectangle()) }) {
        self.placedInToolbar = placedInToolbar
        self.pagerAnimation = pagerAnimation
        self.indicatorViewHeight = indicatorViewHeight
        self.barBackgroundView = barBackgroundView
        self.indicatorView = indicatorView
    }
}

public struct BarButtonStyle: PagerWithIndicatorStyle {

    public var placedInToolbar: Bool
    public var pagerAnimation: Animation
    public var tabItemSpacing: CGFloat
    public var tabItemHeight: CGFloat
    public var scrollable: Bool
    public var padding: EdgeInsets
    public var indicatorViewHeight: CGFloat

    @ViewBuilder public var indicatorView: () -> AnyView
    @ViewBuilder public var barBackgroundView: () -> AnyView

    public init(placedInToolbar: Bool = false, pagerAnimation: Animation = .default, tabItemSpacing: CGFloat = 0, tabItemHeight: CGFloat = 50, scrollable: Bool = false, padding: EdgeInsets = EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10), indicatorViewHeight: CGFloat = 2, @ViewBuilder barBackgroundView: @escaping (() -> AnyView) = { AnyView(EmptyView()) }, @ViewBuilder indicatorView: @escaping (() -> AnyView) = { AnyView(Rectangle().fill(.blue)) }) {
        self.placedInToolbar = placedInToolbar
        self.pagerAnimation = pagerAnimation
        self.tabItemSpacing = tabItemSpacing
        self.tabItemHeight = tabItemHeight
        self.scrollable = scrollable
        self.padding = padding
        self.indicatorView = indicatorView
        self.barBackgroundView = barBackgroundView
        self.indicatorViewHeight = indicatorViewHeight

    }
}

struct CustomStyle: PagerStyle {
    var placedInToolbar: Bool
    var pagerAnimation: Animation
}

private struct PagerStyleKey: EnvironmentKey {
    static let defaultValue: PagerStyle = .barButton()
}

extension EnvironmentValues {
    var pagerStyle: PagerStyle {
        get { self[PagerStyleKey.self] }
        set { self[PagerStyleKey.self] = newValue }
    }
}
