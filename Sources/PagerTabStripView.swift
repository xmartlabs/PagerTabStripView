//
//  PagerTabStripView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

class SelectionState<SelectionType>: ObservableObject {
    @Published var selection: SelectionType

    init(selection: SelectionType) {
        self.selection = selection
    }
}

@available(iOS 16.0, *)
public struct PagerTabStripView<SelectionType, Content>: View where SelectionType: Hashable, Content: View {
    private var content: () -> Content
    private var swipeGestureEnabled: Binding<Bool>
    private var selection: Binding<SelectionType>
    @StateObject private var selectionState: SelectionState<SelectionType>

    public init(swipeGestureEnabled: Binding<Bool> = .constant(true), selection: Binding<SelectionType>,
                @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        self._selectionState = StateObject(wrappedValue: SelectionState(selection: selection.wrappedValue))
        self.selection = selection
        self.content = content
    }

    @MainActor public var body: some View {
        WrapperPagerTabStripView(swipeGestureEnabled: swipeGestureEnabled, selection: selection, content: content)
    }
}

extension PagerTabStripView where SelectionType == Int {

    public init(swipeGestureEnabled: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        let selectionState =  SelectionState(selection: 0)
        self._selectionState = StateObject(wrappedValue: selectionState)
        self.selection = Binding(get: {
            selectionState.selection
        }, set: {
            selectionState.selection = $0
        })
        self.content = content
    }
}

private struct WrapperPagerTabStripView<SelectionType, Content>: View where SelectionType: Hashable, Content: View {

    private var content: Content
    @StateObject private var pagerSettings = PagerSettings<SelectionType>()
    @Environment(\.pagerStyle) var style: PagerStyle
    @Binding private var selection: SelectionType
//    @State private var currentOffset: CGFloat = 0 {
//        didSet {  }
//    }
    @GestureState private var translation: CGFloat = 0
    @Binding private var swipeGestureEnabled: Bool
    @State private var swipeOn: Bool = true

    public init(swipeGestureEnabled: Binding<Bool>, selection: Binding<SelectionType>, @ViewBuilder content: @escaping () -> Content) {
        self._swipeGestureEnabled = swipeGestureEnabled
        self._selection = selection
        self.content = content()
    }

    @MainActor public var body: some View {
        GeometryReader { geometryProxy in
            let dragGesture = DragGesture(minimumDistance: 25)
            .onChanged { value in
                let isSwipingToLeftFromFirstItem = selection == pagerSettings.itemsOrderedByIndex.first && value.translation.width > 0
                let isSwipingToRightFromLastItem = selection == pagerSettings.itemsOrderedByIndex.last && value.translation.width < 0
                swipeOn = !(isSwipingToLeftFromFirstItem || isSwipingToRightFromLastItem)
            }
            .updating(self.$translation) { value, state, _ in
                if selection == pagerSettings.itemsOrderedByIndex.first && value.translation.width > 0 {
                    let valueWidth = value.translation.width
                    let normTrans = valueWidth / (geometryProxy.size.width + 50)
                    let logValue = log(1 + normTrans)
                    state = geometryProxy.size.width/1.5 * logValue
                } else if selection == pagerSettings.itemsOrderedByIndex.last && value.translation.width < 0 {
                    let valueWidth = -value.translation.width
                    let normTrans = valueWidth / (geometryProxy.size.width + 50)
                    let logValue = log(1 + normTrans)
                    state = -geometryProxy.size.width / 1.5 * logValue
                } else {
                    state = value.translation.width
                }
            }.onEnded { value in
                let offset = value.predictedEndTranslation.width / geometryProxy.size.width
                let selectionIndex = pagerSettings.indexOf(tag: selection) ?? 0
                let newPredictedIndex = (CGFloat(selectionIndex) - offset).rounded()
                let newIndex = min(max(Int(newPredictedIndex), 0), pagerSettings.items.count - 1)
                if newIndex > selectionIndex {
                    selection =  pagerSettings.nextSelection(for: selection)
                } else if newIndex < selectionIndex {
                    selection = pagerSettings.previousSelection(for: selection)
                }
                if translation > 0 {
                    pagerSettings.contentOffset = translation
                }
            }
            
            LazyHStack(spacing: 0) {
                content
                    .frame(width: geometryProxy.size.width)
            }
            .coordinateSpace(name: "PagerViewScrollView")
            .offset(x: -CGFloat(pagerSettings.indexOf(tag: selection) ?? 0) * geometryProxy.size.width)
            .offset(x: translation)
            .animation(style.pagerAnimation, value: selection)
            .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), value: translation)
            .gesture(swipeGestureEnabled && swipeOn ? dragGesture : nil)
            .onAppear {
                let frame = geometryProxy.frame(in: .local)
                pagerSettings.width = frame.width
                if let index = pagerSettings.indexOf(tag: selection) {
                    pagerSettings.contentOffset = -CGFloat(index) * frame.width
                }
            }
            .onChange(of: pagerSettings.itemsOrderedByIndex) { _ in
                pagerSettings.contentOffset = -(CGFloat(pagerSettings.indexOf(tag: selection) ?? 0) * geometryProxy.size.width)
            }
            .onChange(of: geometryProxy.frame(in: .local)) { geometry in
                pagerSettings.width = geometry.width
                if let index = pagerSettings.indexOf(tag: selection) {
                    pagerSettings.contentOffset = -(CGFloat(index)) * geometry.width
                }
            }
            .onChange(of: selection) { newSelection in
                pagerSettings.contentOffset = -(CGFloat(pagerSettings.indexOf(tag: newSelection) ?? 0) * geometryProxy.size.width)
                swipeOn = true
            }
            .onChange(of: translation) { _ in
                pagerSettings.contentOffset = translation - (CGFloat(pagerSettings.indexOf(tag: selection) ?? 0) * geometryProxy.size.width)
                swipeOn = true
            }
        }
        .modifier(NavBarModifier(selection: $selection))
        .environmentObject(pagerSettings)
        .clipped()
    }

}
