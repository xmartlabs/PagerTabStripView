//
//  NavBarModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarModifier<SelectionType>: ViewModifier where SelectionType: Hashable {
    @Binding private var selection: SelectionType
	private let isStickToBottom: Bool

	public init(selection: Binding<SelectionType>, isStickToBottom: Bool) {
		self._selection = selection
		self.isStickToBottom = isStickToBottom
	}

    @MainActor func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !style.placedInToolbar {
				if isStickToBottom {
					content
					NavBarWrapperView(selection: $selection)
				} else {
					NavBarWrapperView(selection: $selection)
					content
				}
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

private struct NavBarWrapperView<SelectionType>: View where SelectionType: Hashable {
    @Binding var selection: SelectionType

    @MainActor var body: some View {
        switch style {
        case let barStyle as BarStyle:
            IndicatorBarView<SelectionType, AnyView>(selection: $selection, indicator: barStyle.indicatorView)
        case is SegmentedControlStyle:
            SegmentedNavBarView(selection: $selection)
        case let indicatorStyle as BarButtonStyle:
            if indicatorStyle.scrollable {
                ScrollableNavBarView(selection: $selection)
            } else {
                FixedSizeNavBarView(selection: $selection)
            }
        default:
            SegmentedNavBarView(selection: $selection)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
