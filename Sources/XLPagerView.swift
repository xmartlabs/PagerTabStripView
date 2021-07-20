//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//
import SwiftUI
import Combine

///
/// Private Source Code
///

private struct PagerTabView<Content: View, NavTabView: View>: View {
    @EnvironmentObject internal var navContentViews : DataStore
    private var content: () -> Content
    private var navTabView : () -> NavTabView
    
    init(@ViewBuilder navTabView: @escaping () -> NavTabView, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.navTabView = navTabView
    }
    
    var body: some View {
        content()
    }
}

private struct PagerSetAppearItem: ViewModifier {
    @EnvironmentObject var navContentViews : DataStore
    @EnvironmentObject var pagerSettings: PagerSettings
    var onPageAppear: () -> Void
    @State var index = -1

    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                let frame = reader.frame(in: .named("XLPagerViewScrollView"))
                                index = Int(round((frame.minX - pagerSettings.contentOffset) / pagerSettings.width))
                                navContentViews.setAppear(callback: onPageAppear, at: index)
                            }
                        }
                }
            )
    }
}

private struct PagerTabItem<NavTabView: View> : ViewModifier {
    @EnvironmentObject var navContentViews : DataStore
    @EnvironmentObject var pagerSettings: PagerSettings
    var navTabView: () -> NavTabView
    @State var index = -1
    
    init(navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
        self.index = index
    }
    
    func body(content: Content) -> some View {
        PagerTabView(navTabView: navTabView) {
            content
                .overlay(
                    GeometryReader { reader in
                        Color.clear
                            .onAppear {
                                DispatchQueue.main.async {
                                    let frame = reader.frame(in: .named("XLPagerViewScrollView"))
                                    index = Int(round((frame.minX - pagerSettings.contentOffset) / pagerSettings.width))
                                    let tabView = navTabView()
                                    let tabViewDelegate = navTabView() as? PagerTabViewDelegate
                                    navContentViews.setView(AnyView(tabView),
                                                            tabViewDelegate: tabViewDelegate,
                                                            at: index)
                                }
                            }.onDisappear {
                                navContentViews.items.value[index]?.tabViewDelegate?.setSelectedState(state: .normal)
                                navContentViews.remove(at: index)
                            }
                    }
                )
        }
    }
}

private struct NavBarModifier: ViewModifier {
    @EnvironmentObject var pagerSettings: PagerSettings
    @Binding private var indexSelected: Int
    @Binding private var itemCount: Int
    private var navBarItemWidth: CGFloat {
        let totalItemWidth = (pagerSettings.width - (pagerSettings.tabItemSpacing * CGFloat(itemCount - 1)))
        return totalItemWidth / CGFloat(itemCount)
    }
    
    public init(itemCount: Binding<Int>, selection: Binding<Int>) {
        self._indexSelected = selection
        self._itemCount = itemCount
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: pagerSettings.tabItemSpacing) {
                if itemCount > 0 && pagerSettings.width > 0 {
                    ForEach(0...itemCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $indexSelected)
                            .frame(height: pagerSettings.tabItemHeight, alignment: .center)
                    }
                }
            }
            .frame(height: pagerSettings.tabItemHeight, alignment: .center)
            HStack {
                if let width = navBarItemWidth, width > 0, width <= pagerSettings.width {
                    let x = -self.pagerSettings.contentOffset / CGFloat(itemCount) + width / 2
                    Rectangle()
                        .fill(pagerSettings.indicatorBarColor)
                        .animation(.default)
                        .frame(width: width)
                        .position(x: x, y: 0)
                }
            }
            .frame(height: pagerSettings.indicatorBarHeight)
            content
        }
    }
}

private struct PagerContainerView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

extension PagerContainerView {
    @available(iOS 14.0, *)
    internal func navBar(itemCount: Binding<Int>, selection: Binding<Int>) -> some View {
        return self.modifier(NavBarModifier(itemCount: itemCount, selection: selection))
    }
}


private struct NavBarItem: View {
    @EnvironmentObject var navContentViews: DataStore
    @Binding private var indexSelected: Int
    private var id: Int
    
    public init(id: Int, selection: Binding<Int>) {
        self._indexSelected = selection
        self.id = id
    }
    
    var body: some View {
        if id < navContentViews.items.value.keys.count {
            Button(action: {
                self.indexSelected = id
            }, label: {
                navContentViews.items.value[id]?.view
            }).buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                navContentViews.items.value[id]?.tabViewDelegate?.setSelectedState(state: pressing ? .highlighted : .selected)
            } perform: {}
        }
    }
}


public class PagerSettings: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0
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

///
/// Public Source Code
///

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
                pagerSettings: PagerSettings,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._currentIndex = State(initialValue: selection)
        self._pagerSettings = StateObject(wrappedValue: pagerSettings)
    }
    
    public var body: some View {
        PagerContainerView {
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
                            let normTrans = (valueWidth / (gproxy.size.width + 50))
                            let logValue = log(1 + normTrans)
                            state = gproxy.size.width/1.5 * (logValue)
                        } else if (currentIndex == itemCount - 1 && value.translation.width < 0) {
                            let valueWidth = -value.translation.width
                            let normTrans = (valueWidth / (gproxy.size.width + 50))
                            let logValue = log(1 + normTrans)
                            state = -gproxy.size.width/1.5 * (logValue)
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
                    if let callback = navContentViews.items.value[currentIndex]?.appearCallback {
                        callback()
                    }
                    if let tabViewDelegate = navContentViews.items.value[currentIndex]?.tabViewDelegate {
                        tabViewDelegate.setSelectedState(state: .normal)
                    }
                    if let tabViewDelegate = navContentViews.items.value[newIndex]?.tabViewDelegate, newIndex != currentIndex {
                        tabViewDelegate.setSelectedState(state: .selected)
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
                    pagerSettings.height = gproxy.size.height
                }
            }
        }
        .navBar(itemCount: $itemCount, selection: $currentIndex)
        .environmentObject(self.navContentViews)
        .environmentObject(self.pagerSettings)
        .onReceive(self.navContentViews.items.throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)) { items in
            self.itemCount = items.keys.count
            if let tabViewDelegate = navContentViews.items.value[currentIndex]?.tabViewDelegate {
                tabViewDelegate.setSelectedState(state: .selected)
            }
        }
        .clipped()
    }
    
    private func offsetForPageIndex(_ index: Int) -> CGFloat {
        let value = (CGFloat(index) * pagerSettings.width) * -1.0
        return value
    }
}

public enum PagerTabViewState {
    case selected
    case highlighted
    case normal
}

public protocol PagerTabViewDelegate {
    func setSelectedState(state: PagerTabViewState)
}

extension View {
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View {
        return self.modifier(PagerTabItem(navTabView: pagerTabView))
    }

    public func onPageAppear(perform action: (() -> Void)?) -> some View {
        return self.modifier(PagerSetAppearItem(onPageAppear: action ?? {}))
    }
}
