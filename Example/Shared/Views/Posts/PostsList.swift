//
//  PostsList.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//
import Foundation
import SwiftUI

struct PostsList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    
    var posts: [Post] {
        modelData.posts
    }
    
    
    var body: some View {
        List {
            ForEach(posts) { post in
                PostRow(post: post)
            }
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            PostsList()
                .environmentObject(ModelData())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
