//
//  PagerSetAppearModifier.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerSetAppearItemModifier: ViewModifier {

    private var onPageAppear: () -> Void

    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    dataStore.setAppear(callback: onPageAppear, at: index)
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @State private var index = -1
}
