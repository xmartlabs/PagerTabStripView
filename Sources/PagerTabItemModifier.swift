//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<NavTabView: View>: ViewModifier {

    private var navTabView: () -> NavTabView

    init(navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
    }

    func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        index = Int(round(frame.minX / frame.width))
                        let tabView = navTabView()
                        let tabViewDelegate = tabView as? PagerTabViewDelegate
                        dataStore.setView(AnyView(tabView), at: index)
                        dataStore.setTabViewDelegate(tabViewDelegate, at: index)
                    }
                }.onDisappear {
                    dataStore.items[index]?.tabViewDelegate?.setState(state: .normal)
                    dataStore.remove(at: index)
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @State private var index = -1
}
