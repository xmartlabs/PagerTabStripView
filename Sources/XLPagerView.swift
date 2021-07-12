//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//
import SwiftUI
import Combine

extension View {
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View {
        return self.modifier(PagerTabItem(navTabView: pagerTabView))
    }

    public func onPageAppear(perform action: (() -> Void)? = nil) -> some View {
        return self.modifier(PagerSetAppearItem(onPageAppear: action ?? {}))
    }
}

struct PagerTabView<Content: View, NavTabView: View>: View {
    
    @EnvironmentObject var navContentViews : DataStore
    var content: () -> Content
    var navTabView : () -> NavTabView
    
    init(@ViewBuilder navTabView: @escaping () -> NavTabView, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.navTabView = navTabView
    }
    
    var body: some View {
        content()
    }
}

struct PagerSetAppearItem: ViewModifier {
    @EnvironmentObject var navContentViews : DataStore
    @EnvironmentObject var pagerSettings: PagerSettings
    var onPageAppear: () -> Void
    @State var index = -1

    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    func body(content: Content) -> some View {
        content
            .frame(width: pagerSettings.width, height: pagerSettings.height)
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

struct PagerTabItem<NavTabView: View> : ViewModifier {
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
                .frame(width: pagerSettings.width, height: pagerSettings.height)
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

@available(iOS 14.0, *)
struct NavBarModifier: ViewModifier {
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
            LazyHStack(spacing: pagerSettings.tabItemSpacing) {
                if itemCount > 0 && pagerSettings.width > 0 {
                    ForEach(0...itemCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $indexSelected)
                            .frame(width: navBarItemWidth, height: pagerSettings.tabItemHeight, alignment: .center)
                    }
                }
            }
            .frame(width: pagerSettings.width, height: pagerSettings.tabItemHeight, alignment: .center)
            HStack {
                if let width = navBarItemWidth, width > 0, width <= pagerSettings.width {
                    let x = -self.pagerSettings.contentOffset / CGFloat(itemCount) + width / 2
                    Rectangle()
                        .fill(pagerSettings.indicatorBarColor)
                        .frame(width: width)
                        .position(x: x, y: 0)
                }
            }
            .frame(width: pagerSettings.width, height: pagerSettings.indicatorBarHeight)
            content
        }
    }
}

struct PagerContainerView<Content: View>: View {
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
    public func navBar(itemCount: Binding<Int>, selection: Binding<Int>) -> some View {
        return self.modifier(NavBarModifier(itemCount: itemCount, selection: selection))
    }
}


struct NavBarItem: View {
    
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
                if pressing {
                    navContentViews.items.value[id]?.tabViewDelegate?.setSelectedState(state: .hightlighted)
                } else {
                    navContentViews.items.value[id]?.tabViewDelegate?.setSelectedState(state: .selected)
                }
            } perform: {}
        }
    }
}

public enum PagerType {
    case twitter
    case youtube
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

@available(iOS 14.0, *)
public struct XLPagerView<Content> : View where Content : View {
    
    @StateObject var navContentViews = DataStore()
    @StateObject var pagerSettings = PagerSettings()
    
    private var type: PagerType
    private var content: () -> Content
    
    @State private var currentIndex: Int
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.pagerSettings.contentOffset = currentOffset
        }
    }
    
    @State private var itemCount : Int = 0
    @GestureState private var translation: CGFloat = 0

    public init(_ type: PagerType = .twitter,
                selection: Int = 0,
                pagerSettings: PagerSettings,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
        self._currentIndex = State(initialValue: selection)
        self._pagerSettings = StateObject(wrappedValue: pagerSettings)
    }
    
    func offsetForPageIndex(_ index: Int) -> CGFloat {
        let value = (CGFloat(index) * pagerSettings.width) * -1.0
        return value
    }
    
    public var body: some View {
        PagerContainerView {
            GeometryReader { gproxy in
                HStack(spacing: 0) {
                    content()
                }
                .frame(width: pagerSettings.width, height: pagerSettings.height, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * pagerSettings.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                    }.onEnded { value in
                        let offset = value.predictedEndTranslation.width / pagerSettings.width
                        let newPredictedIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        let newIndex = min(max(Int(newPredictedIndex), 0), self.itemCount - 1)
                        if newIndex != self.currentIndex && abs(self.currentIndex - newIndex) > 1 {
                            self.currentIndex = newIndex > currentIndex ? currentIndex + 1 : currentIndex - 1
                        } else {
                            self.currentIndex = newIndex
                        }
                        if translation > 0 {
                            self.currentOffset = translation
                        }
                    }
                )
                .clipped()
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
    }
}

public enum PagerTabViewState {
    case selected
    case hightlighted
    case normal
}

public protocol PagerTabViewDelegate {
    func setSelectedState(state: PagerTabViewState)
}
