//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<NavTabView>: ViewModifier where NavTabView: View {

    let navTabView: () -> NavTabView
    let tag: Int

    init(tag: Int, navTabView: @escaping () -> NavTabView) {
        self.tag = tag
        self.navTabView = navTabView
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    dataStore.createOrUpdate(tag: tag, index: index, view: AnyView(navTabView()))
                }.onDisappear {
                    dataStore.remove(tag: tag)
                }
                .onChange(of: reader.frame(in: .named("PagerViewScrollView"))) { newFrame in
                    index = Int(round(newFrame.minX / newFrame.width))
                }
                .onChange(of: index) { newValue in
                    dataStore.createOrUpdate(tag: tag, index: newValue, view: AnyView(navTabView()))
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @State private var index = -1
}

private struct PageTabViewKey: EnvironmentKey {
    static let defaultValue: AnyView = AnyView(EmptyView())
}

extension EnvironmentValues {
    var pageTabViewKey: AnyView {
        get { self[PageTabViewKey.self] }
        set { self[PageTabViewKey.self] = newValue }
    }
}
