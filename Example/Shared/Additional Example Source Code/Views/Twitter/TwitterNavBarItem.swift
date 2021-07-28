//
//  TwitterNav.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

private class ButtonTheme: ObservableObject {
    @Published var textColor = Color.gray
}

struct TwitterNavBarItem: View, PagerTabViewDelegate {
    let title: String
    
    @ObservedObject fileprivate var theme = ButtonTheme()
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(theme.textColor)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = .blue
        default:
            self.theme.textColor = .gray
        }
    }
}

struct TwitterNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        TwitterNavBarItem(title: "Tweets")
    }
}
