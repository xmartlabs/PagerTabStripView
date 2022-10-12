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

struct NavBarWrapperView: View {
    @Binding private var selection: Int

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        switch self.style {
        case .bar:
            IndicatorBarView { Rectangle() }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        case .segmentedControl:
            SegmentedNavBarView(selection: $selection)
        case .barButton:
            FixedSizeNavBarView(selection: $selection) { EmptyView() }
            IndicatorBarView { Rectangle() }
        case .scrollableBarButton:
            ScrollableNavBarView(selection: $selection)
        case .custom(_, _, _, let indicator, let background, _):
            FixedSizeNavBarView(selection: $selection) { background() }
            IndicatorBarView { indicator() }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
