//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<SelectionType, NavTabView>: ViewModifier where SelectionType: Hashable, NavTabView: View {

    let navTabView: () -> NavTabView
    let tag: SelectionType

    init(tag: SelectionType, navTabView: @escaping () -> NavTabView) {
        self.tag = tag
        self.navTabView = navTabView
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    dataStore.createOrUpdate(tag: tag, index: index, view: navTabView())
                }.onDisappear {
                    dataStore.remove(tag: tag)
                }
                .onChange(of: reader.frame(in: .named("PagerViewScrollView"))) { newFrame in
                    index = Int(round(newFrame.minX / newFrame.width))
                }
                .onChange(of: index) { newIndex in
                    dataStore.createOrUpdate(tag: tag, index: newIndex, view: navTabView())
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore<SelectionType>
    @State private var index = -1
}
