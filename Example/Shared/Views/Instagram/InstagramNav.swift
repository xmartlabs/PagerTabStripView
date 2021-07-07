//
//  InstagramNav.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import SwiftUI
import PagerTabStrip

private class ButtonTheme: ObservableObject {
    @Published var imageColor = Color.gray
}

struct InstagramNav: View, PagerTabViewDelegate, Equatable {
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
    
    static func ==(lhs: InstagramNav, rhs: InstagramNav) -> Bool {
        return lhs.imageName == rhs.imageName
    }
    
    func setSelectedState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.imageColor = .black
        default:
            self.theme.imageColor = .gray
        }
    }
}

struct InstagramNav_Previews: PreviewProvider {
    static var previews: some View {
        InstagramNav(imageName: "gallery")
    }
}
