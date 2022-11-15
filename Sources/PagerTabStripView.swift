//
//  PagerTabStripView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

class PagerSettings: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
}

@available(iOS 14.0, *)
public struct PagerTabStripView<SelectionType, Content>: View where SelectionType: Hashable, Content: View {
    private var content: () -> Content
    private var swipeGestureEnabled: Binding<Bool>
    
    private var selection: Binding<SelectionType>?
    
    private var selectionState: State<SelectionType>!
    @StateObject private var settings: PagerSettings

    public init(swipeGestureEnabled: Binding<Bool> = .constant(true), selection: Binding<SelectionType>, @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        self.selection = selection
        self.content = content
        self._settings = StateObject(wrappedValue: PagerSettings())
    }

    @MainActor public var body: some View {
        WrapperPagerTabStripView(swipeGestureEnabled: swipeGestureEnabled, selection: selection ?? selectionState.projectedValue, content: content)
            .environmentObject(settings)
    }
}

extension PagerTabStripView where SelectionType == Int {

    public init(swipeGestureEnabled: Binding<Bool> = .constant(true), @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        let initialState = State(initialValue: 0)
        self.selectionState = initialState
        self.selection = initialState.projectedValue
        self.content = content
        self._settings = StateObject(wrappedValue: PagerSettings())
    }
}

private struct WrapperPagerTabStripView<SelectionType, Content>: View where SelectionType: Hashable, Content: View {

    private var content: Content

    @StateObject private var dataStore = DataStore<SelectionType>()
    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
    @Binding private var selection: SelectionType
    @State private var currentOffset: CGFloat = 0 {
        didSet { settings.contentOffset = currentOffset }
    }
    @GestureState private var translation: CGFloat = 0
    @Binding private var swipeGestureEnabled: Bool

    public init(swipeGestureEnabled: Binding<Bool>, selection: Binding<SelectionType>, @ViewBuilder content: @escaping () -> Content) {
        self._swipeGestureEnabled = swipeGestureEnabled
        self._selection = selection
        self.content = content()
    }

    @MainActor public var body: some View {
        GeometryReader { gproxy in
            LazyHStack(spacing: 0) {
                content
                    .frame(width: gproxy.size.width)
            }
            .coordinateSpace(name: "PagerViewScrollView")
            .offset(x: -CGFloat(dataStore.itemsOrderedByIndex.firstIndex(of: selection) ?? 0) * gproxy.size.width)
            .offset(x: translation)
            .animation(style.pagerAnimation, value: selection)
            .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), value: translation)
            .gesture(!swipeGestureEnabled ? nil :
                DragGesture(minimumDistance: 25).updating(self.$translation) { value, state, _ in
                    if selection == dataStore.itemsOrderedByIndex.first && value.translation.width > 0 {
                        let valueWidth = value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = gproxy.size.width/1.5 * logValue
                    } else if selection == dataStore.itemsOrderedByIndex.last && value.translation.width < 0 {
                        let valueWidth = -value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = -gproxy.size.width / 1.5 * logValue
                    } else {
                        state = value.translation.width
                    }
                }.onEnded { value in
                    let offset = value.predictedEndTranslation.width / gproxy.size.width
                    let selectionIndex = dataStore.items[selection]!.index
                    let newPredictedIndex = (CGFloat(selectionIndex) - offset).rounded()
                    let newIndex = min(max(Int(newPredictedIndex), 0), dataStore.itemsCount - 1)
                    if newIndex > selectionIndex {
                        selection =  dataStore.nextSelection(for: selection)
                    } else if newIndex < selectionIndex {
                        selection = dataStore.previousSelection(for: selection)
                    }
                    if translation > 0 {
                        currentOffset = translation
                    }
                }
            }.onEnded { value in
                let offset = value.predictedEndTranslation.width / gproxy.size.width
                let newPredictedIndex = (CGFloat(selection) - offset).rounded()
                let newIndex = min(max(Int(newPredictedIndex), 0), dataStore.itemsCount - 1)
                if abs(selection - newIndex) > 1 {
                    selection = newIndex > selection ? selection + 1 : selection - 1
                } else {
                    selection = newIndex
                }
                if translation > 0 {
                    self.currentOffset = translation
                }
            })
            .onAppear(perform: {
                let geo = gproxy.frame(in: .local)
                settings.width = geo.width
                if let dataItem = dataStore.items[selection] {
                    currentOffset = -(CGFloat(dataItem.index) * geo.width)
                }
            })
            .onChange(of: gproxy.frame(in: .local), perform: { geo in
                settings.width = geo.width
                if let dataItem = dataStore.items[selection] {
                    currentOffset = -(CGFloat(dataItem.index) * geo.width)
                }
            })
            .onChange(of: selection) { [selection] newSelection in
                currentOffset = -(CGFloat(dataStore.items[newSelection]?.index ?? 0) * gproxy.size.width)
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .normal)
                dataStore.items[newSelection]?.tabViewDelegate?.setState(state: .selected)
            }
            .onChange(of: translation) { _ in
                currentOffset = translation - (CGFloat(dataStore.items[selection]?.index ?? 0) * gproxy.size.width)
            }
            .onChange(of: dataStore.itemsOrderedByIndex) { _ in
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .selected)
            }
        }
        .modifier(NavBarModifier(selection: $selection))
        .environmentObject(dataStore)
        .clipped()
    }

}
