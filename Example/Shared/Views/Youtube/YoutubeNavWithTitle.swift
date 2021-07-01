//
//  YoutubeNavWithTitle.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import SwiftUI


let redColor = Color(red: 221/255.0, green: 0/255.0, blue: 19/255.0, opacity: 1.0)
let unselectedIconColor = Color(red: 73/255.0, green: 8/255.0, blue: 10/255.0, opacity: 1.0)

struct YoutubeNavWithTitle: View, Equatable {
    let title: String
    let imageName: String
    var image: Image {
        Image(imageName)
    }
    
    var body: some View {
        VStack {
            image
            Text(title.uppercased())
                .foregroundColor(unselectedIconColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(redColor)
    }

    static func ==(lhs: YoutubeNavWithTitle, rhs: YoutubeNavWithTitle) -> Bool {
        return lhs.title == rhs.title
    }
}

struct YoutubeNavWithTitle_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeNavWithTitle(title: "Home", imageName: "home")
    }
}
