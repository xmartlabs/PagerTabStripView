//
//  YoutubeNavWithTitle.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Combine
import SwiftUI
import PagerTabStripView

let redColor = Color(red: 221/255.0, green: 0/255.0, blue: 19/255.0, opacity: 1.0)
let unselectedColor = Color(red: 73/255.0, green: 8/255.0, blue: 10/255.0, opacity: 1.0)
let selectedColor = Color(red: 234/255.0, green: 234/255.0, blue: 234/255.0, opacity: 0.7)

private class ButtonTheme: ObservableObject {
    @Published var backgroundColor = redColor
    @Published var textColor = unselectedColor
}

struct YoutubeNavBarItem: View, PagerTabViewDelegate {
    let title: String
    let imageName: String
    var image: Image {
        Image(imageName)
    }

    @ObservedObject fileprivate var theme = ButtonTheme()

    @MainActor var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .foregroundColor(theme.textColor)
            Text(title.uppercased())
                .foregroundColor(theme.textColor)
                .fontWeight(.regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundColor)
    }

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = selectedColor
        default:
            self.theme.textColor = unselectedColor
        }
    }
}

struct YoutubeNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeNavBarItem(title: "Home", imageName: "home")
    }
}
