//
//  PagerSetAppearModifier.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

internal struct PagerSetAppearItem: ViewModifier {
    @EnvironmentObject var navContentViews : DataStore
    @EnvironmentObject var pagerSettings: PagerSettings
    var onPageAppear: () -> Void
    @State var index = -1

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
                                let frame = reader.frame(in: .named("XLPagerViewScrollView"))
                                index = Int(round((frame.minX - pagerSettings.contentOffset) / pagerSettings.width))
                                navContentViews.setAppear(callback: onPageAppear, at: index)
                            }
                        }
                }
            )
    }
}
