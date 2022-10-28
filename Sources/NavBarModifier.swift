//
//  NavBarModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    @Binding private var selection: Int

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    @MainActor func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !style.placedInToolbar {
                NavBarWrapperView(selection: $selection)
                content
            } else {
                content.toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        NavBarWrapperView(selection: $selection)
                    }
                })
            }
        }
    }
    @Environment(\.pagerStyle) var style: PagerStyle
}

private struct NavBarWrapperView: View {
    @Binding var selection: Int

    @MainActor var body: some View {
        switch style {
        case let barStyle as BarStyle:
            IndicatorBarView(indicator: barStyle.indicatorView)
        case is SegmentedControlStyle:
            SegmentedNavBarView(selection: $selection)
        case let indicatorStyle as BarButtonStyle:
            if indicatorStyle.scrollable {
                ScrollableNavBarView(selection: $selection)
            } else {
                FixedSizeNavBarView(selection: $selection) { indicatorStyle.barBackgroundView() }
                IndicatorBarView(indicator: indicatorStyle.indicatorView)
            }
        default:
            SegmentedNavBarView(selection: $selection)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
