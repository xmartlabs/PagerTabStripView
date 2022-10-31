//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<NavTabView>: ViewModifier where NavTabView: View {

    private var navTabView: () -> NavTabView

    init(navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    let tabView = navTabView()
                    let tabViewDelegate = tabView as? PagerTabViewDelegate
                    dataStore.setView(AnyView(tabView), at: index)
                    dataStore.setTabViewDelegate(tabViewDelegate, at: index)
                }.onDisappear {
                    dataStore.items[index]?.tabViewDelegate?.setState(state: .normal)
                    dataStore.remove(at: index)
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @State private var index = -1
}
