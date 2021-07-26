//
//  PagerTabItemModifier.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

internal struct PagerTabItem<NavTabView: View> : ViewModifier {
    @EnvironmentObject var navContentViews : DataStore
    @EnvironmentObject var pagerSettings: PagerSettings
    var navTabView: () -> NavTabView
    @State var index = -1

    init(navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
        self.index = index
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
                                let tabView = navTabView()
                                let tabViewDelegate = navTabView() as? PagerTabViewDelegate
                                navContentViews.setView(AnyView(tabView),
                                                        tabViewDelegate: tabViewDelegate,
                                                        at: index)
                            }
                        }.onDisappear {
                            navContentViews.items.value[index]?.tabViewDelegate?.setState(state: .normal)
                            navContentViews.remove(at: index)
                        }
                }
            )
    }
}
