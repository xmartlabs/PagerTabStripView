//
//  Extensions.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

extension View {
    public func pagerTabItem<V>(@ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V: View {
        return self.modifier(PagerTabItemModifier(navTabView: pagerTabView))
    }

    public func onPageAppear(perform action: (() -> Void)?) -> some View {
        return self.modifier(PagerSetAppearItemModifier(onPageAppear: action ?? {}))
    }
    
    public func pagerTabStripViewStyle(_ style: PagerTabViewStyle) -> some View {
        return self.environment(\.customStyleValue, style)
    }
}

private struct CustomStyleKey: EnvironmentKey {
         static let defaultValue = PagerTabViewStyle()
}

extension EnvironmentValues {
    var customStyleValue: PagerTabViewStyle {
        get { self[CustomStyleKey.self] }
        set { self[CustomStyleKey.self] = newValue }
    }
}

//extension EnvironmentValues {
//    static let customStyle: Bool = false
//}
