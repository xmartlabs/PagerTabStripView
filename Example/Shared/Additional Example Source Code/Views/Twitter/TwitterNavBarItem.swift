//
//  TwitterNav.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

private class ButtonTheme: ObservableObject {
    @Published var textColor = Color.gray
}

struct TwitterNavBarItem: View {
    let title: String
    
    @ObservedObject private var theme = ButtonTheme()
    
    @MainActor var body: some View {
        VStack {
            Text(title)
                .foregroundColor(theme.textColor)
                .font(.subheadline)
        }
        .background(Color.clear)
    }
}

extension TwitterNavBarItem: PagerTabViewDelegate {

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            theme.textColor = .blue
        case .highlighted:
            theme.textColor = .red
        default:
            theme.textColor = .gray
        }
    }
}



struct TwitterNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        TwitterNavBarItem(title: "Tweets")
    }
}
