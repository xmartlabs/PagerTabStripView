//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

///
/// Public Source Code
///
public class PagerSettings: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var tabItemSpacing: CGFloat
    @Published var tabItemHeight: CGFloat
    @Published var indicatorBarHeight: CGFloat
    @Published var indicatorBarColor: Color
    @Published var contentOffset: CGFloat = 0
    
    public init(tabItemSpacing: CGFloat = 5, tabItemHeight: CGFloat = 100, indicatorBarHeight: CGFloat = 1.5, indicatorBarColor: Color = .blue) {
        self.tabItemSpacing = tabItemSpacing
        self.tabItemHeight = tabItemHeight
        self.indicatorBarHeight = indicatorBarHeight
        self.indicatorBarColor = indicatorBarColor
    }
}

@available(iOS 14.0, *)
public struct XLPagerView<Content> : View where Content : View {
    
    private var content: () -> Content
    
    @StateObject private var navContentViews = DataStore()
    @StateObject private var pagerSettings = PagerSettings()

    @State private var currentIndex: Int
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.pagerSettings.contentOffset = currentOffset
        }
    }

    @State private var itemCount : Int = 0
    @GestureState private var translation: CGFloat = 0

    public init(selection: Int = 0,
                pagerSettings: PagerSettings = PagerSettings(),
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._currentIndex = State(initialValue: selection)
        self._pagerSettings = StateObject(wrappedValue: pagerSettings)
    }
    
    public var body: some View {
//        PagerContainerView {
            GeometryReader { gproxy in
                HStack(spacing: 0) {
                    content()
                        .frame(width: gproxy.size.width)
                }
                .offset(x: -CGFloat(self.currentIndex) * pagerSettings.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25), value: currentIndex)
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25), value: translation)
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        if (currentIndex == 0 && value.translation.width > 0) {
                            let valueWidth = value.translation.width
                            let normTrans = valueWidth / (gproxy.size.width + 50)
                            let logValue = log(1 + normTrans)
                            state = gproxy.size.width/1.5 * logValue
                        } else if (currentIndex == itemCount - 1 && value.translation.width < 0) {
                            let valueWidth = -value.translation.width
                            let normTrans = valueWidth / (gproxy.size.width + 50)
                            let logValue = log(1 + normTrans)
                            state = -gproxy.size.width / 1.5 * logValue
                        } else {
                            state = value.translation.width
                        }
                    }.onEnded { value in
                        let offset = value.predictedEndTranslation.width / gproxy.size.width
                        let newPredictedIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        let newIndex = min(max(Int(newPredictedIndex), 0), self.itemCount - 1)
                        if abs(self.currentIndex - newIndex) > 1 {
                            self.currentIndex = newIndex > currentIndex ? currentIndex + 1 : currentIndex - 1
                        } else {
                            self.currentIndex = newIndex
                        }
                        if translation > 0 {
                            self.currentOffset = translation
                        }
                    }
                )
                .onChange(of: gproxy.frame(in: .local), perform: { geo in
                    pagerSettings.width = geo.width
                })
                .onChange(of: self.currentIndex) { [currentIndex] newIndex in
                    self.currentOffset = self.offsetForPageIndex(newIndex)
                    if let callback = navContentViews.items.value[newIndex]?.appearCallback {
                        callback()
                    }
                    if let tabViewDelegate = navContentViews.items.value[currentIndex]?.tabViewDelegate {
                        tabViewDelegate.setState(state: .normal)
                    }
                    if let tabViewDelegate = navContentViews.items.value[newIndex]?.tabViewDelegate, newIndex != currentIndex {
                        tabViewDelegate.setState(state: .selected)
                    }
                }
                .onChange(of: translation) { _ in
                    self.pagerSettings.contentOffset = translation - CGFloat(currentIndex)*pagerSettings.width
                }
                .onChange(of: pagerSettings.width) { _ in
                    self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                }
                .onChange(of: itemCount) { _ in
                    currentIndex = currentIndex >= itemCount ? itemCount - 1 : currentIndex
                }
                .onAppear {
                    pagerSettings.width = gproxy.size.width
                }
//            }
        }
        .navBar(itemCount: $itemCount, selection: $currentIndex)
        .environmentObject(self.navContentViews)
        .environmentObject(self.pagerSettings)
        .onReceive(self.navContentViews.items.throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)) { items in
            self.itemCount = items.keys.count
            if let tabViewDelegate = navContentViews.items.value[currentIndex]?.tabViewDelegate {
                tabViewDelegate.setState(state: .selected)
            }
        }
        .clipped()
    }
    
    private func offsetForPageIndex(_ index: Int) -> CGFloat {
        let value = (CGFloat(index) * pagerSettings.width) * -1.0
        return value
    }
}

//private struct PagerContainerView<Content: View>: View {
//    let content: () -> Content
//
//    init(@ViewBuilder content: @escaping () -> Content) {
//        self.content = content
//    }
//
//    var body: some View {
//        content()
//    }
//}
//
//extension PagerContainerView {
//    @available(iOS 14.0, *)
//    internal func navBar(itemCount: Binding<Int>, selection: Binding<Int>) -> some View {
//        return self.modifier(NavBarModifier(itemCount: itemCount, selection: selection))
//    }
//}
