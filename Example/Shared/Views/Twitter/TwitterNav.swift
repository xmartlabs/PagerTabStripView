//
//  TwitterNav.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import SwiftUI
import PagerTabStrip

private class ButtonTheme: ObservableObject {
    @Published var textColor = Color.gray
}

struct TwitterNav: View, PagerTabViewDelegate, Equatable {
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
    
    static func ==(lhs: TwitterNav, rhs: TwitterNav) -> Bool {
        return lhs.title == rhs.title
    }
    
    func setSelectedState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = .blue
        default:
            self.theme.textColor = .gray
        }
    }
}

struct TwitterNav_Previews: PreviewProvider {
    static var previews: some View {
        TwitterNav(title: "Tweets")
    }
}
