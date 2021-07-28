//
//  InstagramNav.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

private class ButtonTheme: ObservableObject {
    @Published var imageColor = Color.gray
}

struct InstagramNavBarItem: View, PagerTabViewDelegate {
    let imageName: String
    var image: Image {
        Image(imageName)
    }
    
    @ObservedObject fileprivate var theme = ButtonTheme()
    
    var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 25.0, height: 25.0)
                .foregroundColor(theme.imageColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.imageColor = .black
        default:
            self.theme.imageColor = .gray
        }
    }
}

struct InstagramNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        InstagramNavBarItem(imageName: "gallery")
    }
}
