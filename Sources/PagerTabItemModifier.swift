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
    var id: String?
    
    init(tag: SelectionType, id: String? = nil, navTabView: @escaping () -> NavTabView) {
        self.tag = tag
        self.id = id
        self.navTabView = navTabView
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { geometryProxy in
            content
                .onAppear {
                    let frame = geometryProxy.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    pagerSettings.createOrUpdate(tag: tag, id: id, index: index, view: navTabView())
                }
                .onDisappear {
                    pagerSettings.remove(tag: tag)
                }
                .onChange(of: geometryProxy.frame(in: .named("PagerViewScrollView"))) { newFrame in
                    index = Int(round(newFrame.minX / newFrame.width))
                }
                .onChange(of: index) { newIndex in
                    pagerSettings.createOrUpdate(tag: tag, id: id, index: newIndex, view: navTabView())
                }
                .onChange(of: id) { newID in
                    pagerSettings.createOrUpdate(tag: tag, id: newID, index: index, view: navTabView())
                }
                .task {
                    pagerSettings.createOrUpdate(tag: tag, id: id, index: index, view: navTabView())
                }
                .id(id)
        }
    }

    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @State private var index = -1
}
