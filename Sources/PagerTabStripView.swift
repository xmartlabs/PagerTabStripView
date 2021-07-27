//
//  PagerView.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

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
public struct PagerTabStripView<Content> : View where Content: View {
    
    private var content: () -> Content
    
    @StateObject private var navContentViews = DataStore()
    @StateObject private var settings = PagerSettings()

    @Binding var selection: Int
    @State private var currentOffset: CGFloat = 0 {
        didSet {
            self.settings.contentOffset = currentOffset
        }
    }

    @State private var itemCount : Int = 0
    @GestureState private var translation: CGFloat = 0

    public init(selection: Binding<Int>? = nil,
                settings: PagerSettings = PagerSettings(),
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._selection = selection ?? .constant(0)
        self._settings = StateObject(wrappedValue: settings)
    }
    
    public var body: some View {
        GeometryReader { gproxy in
            HStack(spacing: 0) {
                content()
                    .frame(width: gproxy.size.width)
            }
            .offset(x: -CGFloat(self.selection) * settings.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25), value: selection)
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    if (selection == 0 && value.translation.width > 0) {
                        let valueWidth = value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = gproxy.size.width/1.5 * logValue
                    } else if (selection == itemCount - 1 && value.translation.width < 0) {
                        let valueWidth = -value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = -gproxy.size.width / 1.5 * logValue
                    } else {
                        state = value.translation.width
                    }
                }.onEnded { value in
                    let offset = value.predictedEndTranslation.width / gproxy.size.width
                    let newPredictedIndex = (CGFloat(self.selection) - offset).rounded()
                    let newIndex = min(max(Int(newPredictedIndex), 0), self.itemCount - 1)
                    if abs(self.selection - newIndex) > 1 {
                        self.selection = newIndex > self.selection ? self.selection + 1 : self.selection - 1
                    } else {
                        self.selection = newIndex
                    }
                    if translation > 0 {
                        self.currentOffset = translation
                    }
                }
            )
            .onChange(of: gproxy.frame(in: .local), perform: { geo in
                self.settings.width = geo.width
            })
            .onChange(of: self.selection) { [selection] newIndex in
                self.currentOffset = self.offsetFor(index: newIndex)
                if let callback = navContentViews.items.value[newIndex]?.appearCallback {
                    callback()
                }
                if let tabViewDelegate = navContentViews.items.value[selection]?.tabViewDelegate {
                    tabViewDelegate.setState(state: .normal)
                }
                if let tabViewDelegate = navContentViews.items.value[newIndex]?.tabViewDelegate, newIndex != selection {
                    tabViewDelegate.setState(state: .selected)
                }
            }
            .onChange(of: translation) { _ in
                self.settings.contentOffset = translation - CGFloat(selection)*settings.width
            }
            .onChange(of: settings.width) { _ in
                self.currentOffset = self.offsetFor(index: self.selection)
            }
            .onChange(of: itemCount) { _ in
                self.selection = selection >= itemCount ? itemCount - 1 : selection
            }
            .onAppear {
                settings.width = gproxy.size.width
            }
        }
        .modifier(NavBarModifier(itemCount: $itemCount, selection: $selection))
        .environmentObject(self.navContentViews)
        .environmentObject(self.settings)
        .onReceive(self.navContentViews.items.throttle(for: 0.05, scheduler: DispatchQueue.main, latest: true)) { items in
            self.itemCount = items.keys.count
            if let tabViewDelegate = navContentViews.items.value[selection]?.tabViewDelegate {
                tabViewDelegate.setState(state: .selected)
            }
        }
        .clipped()
    }
    
    private func offsetFor(index: Int) -> CGFloat {
        return -(CGFloat(index) * settings.width)
    }
}
