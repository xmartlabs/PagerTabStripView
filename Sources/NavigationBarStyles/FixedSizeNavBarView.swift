//
//  FixedSizeNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
internal struct FixedSizeNavBarView<SelectionType>: View where SelectionType: Hashable {

    @Binding private var selection: SelectionType
    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @State private var appeared = false

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            Group {
                FixedSizeNavBarViewLayout(spacing: internalStyle.tabItemSpacing) {
                    ForEach(pagerSettings.itemsOrderedByIndex, id: \.self) { tag in
                        NavBarItem(id: tag, selection: $selection)
                            .tag(tag)
                    }
                    internalStyle.indicatorView()
                        .frame(height: internalStyle.indicatorViewHeight)
                        .layoutValue(key: PagerOffset.self, value: pagerSettings.contentOffset)
                        .layoutValue(key: PagerWidth.self, value: pagerSettings.width)
                        .animation(appeared ? .default : .none, value: pagerSettings.contentOffset)
                }
                .frame(height: internalStyle.tabItemHeight)
                .padding(internalStyle.padding)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        appeared = true
                    }
                }
                .onDisappear {
                    appeared = false
                }
            }
            .background(internalStyle.barBackgroundView())
        }
    }

}

@available(iOS 16.0, *)
struct FixedSizeNavBarViewLayout: Layout {

    let spacing: CGFloat

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Calculate and return the size of the layout container.
        var tabsIndices = subviews.indices
        let indicatorIndex = tabsIndices.removeLast()
        let tabsViews = subviews[tabsIndices]
        let indicatorSubview = subviews[indicatorIndex]

        let tabsSize = tabsViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = tabsSize.map { $0.height }.reduce(.zero) { max($0, $1) }
        let fullSpacing = tabsViews.count > 1 ?  CGFloat(tabsViews.count - 1) * self.spacing : CGFloat.zero
        let height = proposal.replacingUnspecifiedDimensions().height
        let width = proposal.replacingUnspecifiedDimensions().width
        let size = CGSize(width: max(width, tabsSize.map { $0.width }.reduce(0, +) + fullSpacing),
                          height: max(height, maxHeight + indicatorSubview.sizeThatFits(.unspecified).height))
        return size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Tell each subview where to appear.
        guard subviews.count > 1 else { return }

        var tabsIndices = subviews.indices
        let indicatorIndex = tabsIndices.removeLast()
        let tabsViews = subviews[tabsIndices]
        let indicatorSubview = subviews[indicatorIndex]
        let indicatorViewSize =  indicatorSubview.sizeThatFits(.unspecified)

        let tabsSize = tabsViews.map { $0.sizeThatFits(.unspecified) }
        let totalSpacing = tabsViews.count > 1 ?  CGFloat(tabsViews.count - 1) * self.spacing : CGFloat.zero
        let maxHeight = tabsSize.map { $0.height }.reduce(CGFloat.zero) { max($0, $1) }

        let sizeProposal = ProposedViewSize(width: (proposal.width! - totalSpacing) / CGFloat(tabsViews.count), height: maxHeight)
        let fixedWidhtSubview = (proposal.width! - totalSpacing) / CGFloat(tabsViews.count)
        var x = bounds.minX + fixedWidhtSubview / 2

        for index in tabsViews.indices {
            let spacing = index < tabsViews.indices.last! ? self.spacing : CGFloat.zero
            let tabView = subviews[index]
            tabView.place(at: CGPoint(x: x, y: bounds.midY - (indicatorViewSize.height / 2)),
                          anchor: .center,
                          proposal: sizeProposal)
            x += spacing + fixedWidhtSubview
        }

        let contentOffset = -indicatorSubview[PagerOffset.self]
        let itemsCount = tabsViews.count
        let pagerWidth = indicatorSubview[PagerWidth.self]

        guard itemsCount > 0, pagerWidth > 0 else {
            indicatorSubview.place(at: CGPoint(x: 0, y: 0), proposal: .zero)
            return
        }

        let indicatorWidth = proposal.width! / CGFloat(itemsCount)
        let indicatorX =  bounds.minX + ((contentOffset * (proposal.width! / pagerWidth)) / CGFloat(itemsCount)) + (indicatorWidth / 2)
        indicatorSubview.place(at: CGPoint(x: indicatorX, y: bounds.maxY - (indicatorViewSize.height / 2)),
                               anchor: .center,
                               proposal: ProposedViewSize(width: indicatorWidth, height: indicatorViewSize.height))
    }
}
