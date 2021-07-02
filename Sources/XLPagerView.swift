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
        content()
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
            }).font(indexSelected == id ? Font.footnote.weight(.bold) : Font.footnote.weight(.regular))
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

    @State private var currentIndex: Int {
        didSet {
            let tabItem = navContentViews.items.value[currentIndex] as? PagerTabViewProtocol
            print(navContentViews.items.value[currentIndex])
            if (tabItem != nil) {
                tabItem?.setState(state: .selected)
            }
        }
    }
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.pagerSettings.contentOffset = currentOffset
        }
    }

    @State private var contentWidth : CGFloat = 0
    @State private var itemCount : Int = 0
    @State var dragOffset : CGFloat = 0
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
        VStack {
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
                            let offset = value.translation.width / pagerSettings.width
                            let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                            self.currentIndex = min(max(Int(newIndex), 0), self.itemCount - 1)
                            if translation > 0 {
                                self.currentOffset = translation
                            }
                        }
                    )
                    .onChange(of: self.currentIndex) { index in
                        self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                        self.dragOffset = 0
                    }
                    .onChange(of: self.pagerSettings.width) { _ in
                        self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                        self.dragOffset = 0
                    }
                    .onChange(of: itemCount) { _ in
                        currentIndex = currentIndex >= itemCount ? itemCount - 1 : currentIndex
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
                Text("Offset: \(self.currentOffset), Translation: \(self.translation) Page: \(self.currentIndex + 1)")
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
