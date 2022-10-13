//
//  InstagramNav.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

private class ButtonTheme: ObservableObject {
    @Published var imageColor = Color(UIColor.systemGray2)
}

struct InstagramNavBarItem: View {
    let imageName: String
    var image: Image {
        Image(imageName)
    }
    
    @ObservedObject private var theme = ButtonTheme()
    
    @MainActor var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 25.0, height: 25.0)
                .foregroundColor(theme.imageColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

extension InstagramNavBarItem: PagerTabViewDelegate {
    
    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            theme.imageColor = Color(.systemGray)
        default:
            theme.imageColor = Color(.systemGray2)
        }
    }
}

struct InstagramNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        InstagramNavBarItem(imageName: "gallery")
    }
}
