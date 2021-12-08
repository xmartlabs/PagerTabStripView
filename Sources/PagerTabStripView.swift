//
//  PagerView.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

class PagerSettings: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
}

@available(iOS 14.0, *)
public struct PagerTabStripView<Content>: View where Content: View {
    private var content: () -> Content

    @Binding private var selectionBiding: Int
    @State private var selectionState = 0
    @StateObject private var settings: PagerSettings
    private var useBinding: Bool
    private let swipeGestureEnabled: Bool
    
    public init(swipeGestureEnabled: Bool = true,
                selection: Binding<Int>? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        if let selection = selection {
            useBinding = true
            self._selectionBiding = selection
        } else {
            useBinding = false
            self._selectionBiding = .constant(0)
        }
        self.swipeGestureEnabled = swipeGestureEnabled
        self._settings = StateObject(wrappedValue: PagerSettings())
    }

    public var body: some View {
        WrapperPagerTabStripView(swipeGestureEnabled: swipeGestureEnabled, selection: useBinding ? $selectionBiding : $selectionState, content: content)
            .environmentObject(self.settings)
    }
}

private struct WrapperPagerTabStripView<Content>: View where Content: View {

    private var content: () -> Content

    @StateObject private var dataStore = DataStore()

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
    @Binding var selection: Int {
        didSet {
            if selection < 0 {
                selection = oldValue
            }
        }
    }
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.settings.contentOffset = currentOffset
        }
    }
    @GestureState private var translation: CGFloat = 0

    private let swipeGestureEnabled: Bool

    public init(swipeGestureEnabled: Bool = true,
                selection: Binding<Int>,
                @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        self.content = content
        self._selection = selection
    }

    public var body: some View {
        GeometryReader { gproxy in
            LazyHStack(spacing: 0) {
                content()
                    .frame(width: gproxy.size.width)
            }
            .coordinateSpace(name: "PagerViewScrollView")
            .offset(x: -CGFloat(self.selection) * gproxy.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25), value: selection)
            .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    guard swipeGestureEnabled else { return }
                    if (selection == 0 && value.translation.width > 0) {
                        let valueWidth = value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = gproxy.size.width/1.5 * logValue
                    } else if selection == dataStore.itemsCount - 1 && value.translation.width < 0 {
                        let valueWidth = -value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = -gproxy.size.width / 1.5 * logValue
                    } else {
                        state = value.translation.width
                    }
                }.onEnded { value in
                    guard swipeGestureEnabled else { return }
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
                }
            )
            .onAppear(perform: {
                let geo = gproxy.frame(in: .local)
                self.settings.width = geo.width
                self.currentOffset = -(CGFloat(selection) * geo.width)
            })
            .onChange(of: gproxy.frame(in: .local), perform: { geo in
                self.settings.width = geo.width
                self.currentOffset = -(CGFloat(selection) * geo.width)
            })
            .onChange(of: self.selection) { [selection] newIndex in
                self.currentOffset = -(CGFloat(newIndex) * gproxy.size.width)
                dataStore.items[newIndex]?.appearCallback?()
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .normal)
                if let tabViewDelegate = dataStore.items[newIndex]?.tabViewDelegate, newIndex != selection {
                    tabViewDelegate.setState(state: .selected)
                }
            }
            .onChange(of: translation) { _ in
                self.settings.contentOffset = translation - CGFloat(selection)*gproxy.size.width
            }
            .onChange(of: dataStore.itemsCount) { _ in
                self.selection = selection >= dataStore.itemsCount ? dataStore.itemsCount - 1 : selection
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .selected)
                dataStore.items[selection]?.appearCallback?()
            }
        }
        .modifier(NavBarModifier(selection: $selection))
        .environmentObject(self.dataStore)
        .clipped()
    }

}
