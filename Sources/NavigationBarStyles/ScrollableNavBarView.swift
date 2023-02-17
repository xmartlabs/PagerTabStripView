//
//  ScrollableNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
internal struct ScrollableNavBarView<SelectionType>: View where SelectionType: Hashable {

    @Binding var selection: SelectionType
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @Environment(\.pagerStyle) private var style: PagerStyle
    @State private var appeared = false

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollableNavBarViewLayout(spacing: internalStyle.tabItemSpacing) {
                        ForEach(pagerSettings.itemsOrderedByIndex, id: \.self) { tag in
                            NavBarItem(id: tag, selection: $selection)
                                .tag(tag)
                        }
                        internalStyle.indicatorView()
                            .frame(height: internalStyle.indicatorViewHeight)
                            .layoutValue(key: PagerWidth.self, value: pagerSettings.width)
                            .layoutValue(key: PagerOffset.self, value: pagerSettings.contentOffset)
                            .animation(appeared ? .default : .none, value: pagerSettings.contentOffset)
                    }
                    .frame(height: internalStyle.tabItemHeight)
                }
                .background(internalStyle.barBackgroundView())
                .padding(internalStyle.padding)
                .onChange(of: pagerSettings.itemsOrderedByIndex) { _ in
                    if pagerSettings.items[selection] != nil {
                        proxy.scrollTo(selection, anchor: .center)
                    }
                }
                .onChange(of: selection) { newSelection in
                    withAnimation {
                        if pagerSettings.items[newSelection] != nil {
                            proxy.scrollTo(newSelection, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if pagerSettings.items[selection] != nil {
                            proxy.scrollTo(selection, anchor: .center)
                        }
                        appeared = true
                    }
                }
                .onDisappear {
                    appeared = false
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct ScrollableNavBarViewLayout: Layout {

    private let spacing: CGFloat

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Calculate and return the size of the layout container.
        var tabBarIndices = subviews.indices
        let indicatorIndex = tabBarIndices.removeLast()
        let tabBarViews = subviews[tabBarIndices]
        let indicatorSubview = subviews[indicatorIndex]

        let subviewSize = tabBarViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = subviewSize.map { $0.height }.reduce(CGFloat.zero) { max($0, $1) }
        let fullSpacing = tabBarViews.count > 1 ?  CGFloat(tabBarViews.count - 1) * self.spacing : CGFloat.zero
        let height = proposal.replacingUnspecifiedDimensions().height
        return CGSize(width: subviewSize.map { $0.width }.reduce(0, +) + fullSpacing,
                      height: max(height, maxHeight + indicatorSubview.sizeThatFits(.unspecified).height))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var tabBarIndices = subviews.indices
        let indicatorIndex = tabBarIndices.removeLast()
        let tabBarViews = subviews[tabBarIndices]
        let indicatorSubview = subviews[indicatorIndex]
        let indicatorViewSize =  indicatorSubview.sizeThatFits(.unspecified)

        if tabBarViews.count == 0 { return }
        let subviewSize = tabBarViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = subviewSize.map { $0.height }.reduce(CGFloat.zero, max)
        var x = bounds.minX
        var itemsFrames = [CGRect]()

        for index in tabBarIndices.indices {
            let spacing = index < tabBarIndices.indices.last! ? self.spacing : CGFloat.zero
            let subview = subviews[index]
            x += subviewSize[index].width / 2
            let point = CGPoint(x: x, y: bounds.midY - (indicatorViewSize.height / 2))
            let proposedSize = ProposedViewSize(width: subviewSize[index].width, height: maxHeight)
            subview.place(at: point, anchor: .center, proposal: proposedSize)
            itemsFrames.append(CGRect(origin: point, size: CGSize(width: proposedSize.width!, height: proposedSize.height!)))
            x += subviewSize[index].width / 2 + spacing
        }

        let contentOffset = -indicatorSubview[PagerOffset.self]
        let itemsCount = tabBarViews.count
        let pagerWidth = indicatorSubview[PagerWidth.self]
        let indexAndPercentage = contentOffset / pagerWidth
        let percentage = (indexAndPercentage + 1).truncatingRemainder(dividingBy: 1)
        let lowIndex = floor(indexAndPercentage)
        guard lowIndex < CGFloat(itemsCount) else {
            indicatorSubview.place(at: CGPoint(x: 0, y: bounds.maxY - (indicatorViewSize.height / 2)),
                                   anchor: .center,
                                   proposal: ProposedViewSize.zero)
            return
        }
        let currentWidth = itemsFrames[max(0, Int(lowIndex))].size.width
        let nextWidth = itemsFrames[min(itemsCount - 1, Int(lowIndex + 1))].size.width
        let currentPosition = lowIndex >= 0 ? itemsFrames[Int(lowIndex)].origin.x : itemsFrames[0].origin.x - currentWidth
        let nextPosition = lowIndex + 1 < CGFloat(itemsCount - 1)
            ? itemsFrames[Int(lowIndex + 1)].origin.x
            : itemsFrames[Int(itemsCount - 1)].origin.x + nextWidth
        let proposedWidth = currentWidth + ((nextWidth - currentWidth) * percentage)
        let proposedPosition = currentPosition + ((nextPosition - currentPosition) * percentage)
        indicatorSubview.place(at: CGPoint(x: proposedPosition, y: bounds.maxY - (indicatorViewSize.height / 2)),
                               anchor: .center,
                               proposal: ProposedViewSize(width: proposedWidth, height: indicatorViewSize.height))
    }

}

struct PagerOffset: LayoutValueKey {
    static let defaultValue: CGFloat = 0
}

struct PagerWidth: LayoutValueKey {
    static let defaultValue: CGFloat = 0
}
