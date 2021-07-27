//
//  LikedModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class LikedModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "liked")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
