//
//  InstagramNav.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import SwiftUI

struct InstagramNav: View, Equatable {
    let title: String
    
    var body: some View {
        VStack {
            Text(title.uppercased())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    static func ==(lhs: InstagramNav, rhs: InstagramNav) -> Bool {
        return lhs.title == rhs.title
    }
}

struct InstagramNav_Previews: PreviewProvider {
    static var previews: some View {
        InstagramNav(title: "Following")
    }
}
