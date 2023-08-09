//
//  NavBarModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct NavBarModifier<SelectionType>: ViewModifier where SelectionType: Hashable {
    @Binding private var selection: SelectionType

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !style.placedInToolbar {
                NavBarWrapperView<SelectionType>(selection: $selection)
                content
            } else {
                content.toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        NavBarWrapperView<SelectionType>(selection: $selection)
                    }
                })
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}

private struct NavBarWrapperView<SelectionType>: View where SelectionType: Hashable {
    @Binding var selection: SelectionType

    @MainActor var body: some View {
        switch style {
        case let barStyle as BarStyle:
            IndicatorBarView<SelectionType, AnyView>(selection: $selection, indicator: barStyle.indicatorView)
        case is SegmentedControlStyle:
            SegmentedNavBarView<SelectionType>(selection: $selection)
        case let indicatorStyle as BarButtonStyle:
            if #available(iOS 16, *) {
                if indicatorStyle.scrollable {
                    ScrollableNavBarView<SelectionType>(selection: $selection)
                } else {
                    FixedSizeNavBarView<SelectionType>(selection: $selection)
                }
            } else {
                SegmentedNavBarView<SelectionType>(selection: $selection)
            }
        default:
            SegmentedNavBarView<SelectionType>(selection: $selection)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
#endif
