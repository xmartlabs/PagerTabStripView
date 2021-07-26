//
//  NavBarModifier.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

///
/// Private Source Code
///
internal extension GeometryReader {
    func navBar(itemCount: Binding<Int>, selection: Binding<Int>) -> some View {
        return self.modifier(NavBarModifier(itemCount: itemCount, selection: selection))
    }
}

///
/// Public Source Code
///
extension View {
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View {
        return self.modifier(PagerTabItem(navTabView: pagerTabView))
    }

    public func onPageAppear(perform action: (() -> Void)?) -> some View {
        return self.modifier(PagerSetAppearItem(onPageAppear: action ?? {}))
    }
}
