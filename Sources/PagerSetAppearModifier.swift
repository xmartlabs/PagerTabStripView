//
//  PagerSetAppearModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerSetAppearItemModifier: ViewModifier {
    
    private var onPageAppear: () -> Void
    
    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                let frame = reader.frame(in: .named("PagerViewScrollView"))
                                index = Int(round((frame.minX - settings.contentOffset) / settings.width))
                                dataStore.setAppear(callback: onPageAppear, at: index)
                            }
                        }
                }
            )
    }
    
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @Environment(\.pagerStyle) var style: PagerStyle
    @State private var index = -1
}
