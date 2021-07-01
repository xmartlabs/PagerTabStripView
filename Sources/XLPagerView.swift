//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//

import SwiftUI
import Combine


extension View {
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View, V: Equatable, V: PagerTabViewProtocol {
        return self.modifier(PagerTabItem(navTabView: pagerTabView))
    }
}

struct PagerTabView<Content: View, NavTabView: View>: View {

    @EnvironmentObject var navContentViews : NavContentViews
    var content: () -> Content
    var navTabView : () -> NavTabView

    init(@ViewBuilder navTabView: @escaping () -> NavTabView, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.navTabView = navTabView
    }

    var body: some View {
        content().onAppear {
//            navContentViews.items.insert(title, at: 0)
        }
    }
}

struct PagerTabItem<NavTabView: View> : ViewModifier where NavTabView: Equatable {
    @EnvironmentObject var navContentViews : NavContentViews
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
                                var views = navContentViews.items.value
                                views[index] = AnyView(navTabView())
                                navContentViews.items.send(views)
                            }
                        }.onDisappear {
                            var views = navContentViews.items.value
                            views[index] = nil
                            navContentViews.items.send(views)
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

    public init(itemCount: Binding<Int>, selection: Binding<Int>) {
        self._indexSelected = selection
        self._itemCount = itemCount
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            LazyHStack(spacing: pagerSettings.tabItemSpacing) {
                if itemCount > 0 && pagerSettings.width > 0 {
                    let totalItemWidth = (pagerSettings.width - (pagerSettings.tabItemSpacing * CGFloat(itemCount - 1)))
                    let navBarItemWidth: CGFloat = totalItemWidth / CGFloat(itemCount)
                    ForEach(0...itemCount-1, id: \.self) { idx in
                        NavBarItem(id: idx, selection: $indexSelected)
                            .frame(width: navBarItemWidth, height: pagerSettings.tabItemHeight, alignment: .center)
                    }
                }
            }
            .frame(width: pagerSettings.width, height: pagerSettings.tabItemHeight, alignment: .center)
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

    @EnvironmentObject var navContentViews: NavContentViews
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
                navContentViews.items.value[id]
            })//.font(indexSelected == id ? Font.footnote.weight(.bold) : Font.footnote.weight(.regular))
        }
    }
}

public enum PagerType {
    case twitter
    case youtube
}

public class NavContentViews: ObservableObject {
    var items = CurrentValueSubject<[Int: AnyView], Never>([:])
}

public class PagerSettings: ObservableObject {
    @Published var width: CGFloat
    @Published var height: CGFloat
    @Published var tabItemSpacing: CGFloat
    @Published var tabItemHeight: CGFloat
    @Published var contentOffset: CGFloat = 0
    
    public init(width: CGFloat = 0, height: CGFloat = 0, tabItemSpacing: CGFloat = 5, tabItemHeight: CGFloat = 100) {
        self.width = width
        self.height = height
        self.tabItemSpacing = tabItemSpacing
        self.tabItemHeight = tabItemHeight
    }
}

@available(iOS 14.0, *)
public struct XLPagerView<Content> : View where Content : View {

    @StateObject var navContentViews = NavContentViews()
    @StateObject var pagerSettings = PagerSettings()

    private var type: PagerType
    private var content: () -> Content
    
    @State private var currentIndex: Int
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.pagerSettings.contentOffset = currentOffset
        }
    }

    @State private var contentWidth : CGFloat = 0
    @State private var itemCount : Int = 0
    @State var dragOffset : CGFloat = 0

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
    
//    func indexPageForOffset(_ offset : CGFloat) -> Int {
//        guard self.itemCount > 0 else {
//            return 0
//        }
//        let floatIndex = (offset * -1) / pageWidth
//        var computedIndex = Int(round(floatIndex))
//        computedIndex = max(computedIndex, 0)
//        return min(computedIndex, self.itemCount - 1)
//    }

    public var body: some View {
        VStack {
            PagerContainerView {
                GeometryReader { gproxy in
                    ScrollViewReader { sproxy in
                        ScrollView(.horizontal) {
                            ZStack(alignment: .leading) {
                                HStack(spacing: 0) {
                                    self.content().frame(width: self.pagerSettings.width,
                                                         height: self.pagerSettings.height,
                                                         alignment: .center)
                                }
                                .offset(x: self.currentOffset)
                                .animation(.interactiveSpring())
                                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onChanged { value in
                                        let previousTranslation = self.dragOffset
                                        self.currentOffset += value.translation.width - previousTranslation
                                        self.dragOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        let dragged = value.translation.width
                                        if dragged < 0 {
                                            self.currentIndex = min(self.currentIndex + 1, self.navContentViews.items.value.count - 1)
                                            if self.currentIndex == self.navContentViews.items.value.count - 1 {
                                                self.currentOffset = self.offsetForPageIndex(self.navContentViews.items.value.count - 1)
                                                self.dragOffset = 0
                                            }
                                        } else if self.dragOffset > 0 {
                                            self.currentIndex = max(self.currentIndex - 1, 0)
                                            if currentIndex == 0 {
                                                self.currentOffset = 0
                                                self.dragOffset = 0
                                            }
                                        }
                                    }
                                )
                                GeometryReader { pproxy in
                                    Color.clear.frame(width: 10, height: 10, alignment: .leading)
                                        .onAppear {
                                            self.currentOffset = pproxy.frame(in: .local).minX
                                            self.contentWidth = pproxy.frame(in: .local).width
                                        }
                                }
                            }
                        }
                        .coordinateSpace(name: "XLPagerViewScrollView")
                        .frame(width: self.pagerSettings.width, height: self.pagerSettings.height)
                        .onChange(of: self.currentIndex) { index in
                            self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                            self.dragOffset = 0
                            withAnimation {
                                sproxy.scrollTo(index)
                            }
                        }
                        .onChange(of: self.pagerSettings.width) { _ in
                            self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                            self.dragOffset = 0
                            withAnimation {
                                sproxy.scrollTo(currentIndex)
                            }
                        }
                        .onChange(of: itemCount) { _ in
                            currentIndex = currentIndex >= itemCount ? itemCount - 1 : currentIndex
                        }
                    }
                    .onAppear {
                        if pagerSettings.width == 0 {
                            pagerSettings.width = gproxy.size.width
                        }
                    }
                }
            }
            .navBar(itemCount: $itemCount, selection: $currentIndex)
            HStack {
                Text("Offset: \(self.currentOffset) Page: \(self.currentIndex + 1)")
            }
        }
        .environmentObject(self.navContentViews)
        .environmentObject(self.pagerSettings)
        .onReceive(self.navContentViews.items.throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)) { items in
            self.itemCount = items.keys.count
        }
    }
}

public enum PagerTabViewState {
    case selected
    case hightlighted
    case normal
}

public protocol PagerTabViewProtocol {
    func setState(state: PagerTabViewState)
}
