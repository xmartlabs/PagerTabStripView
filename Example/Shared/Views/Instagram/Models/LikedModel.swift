//
//  LikedModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class LikedModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "liked")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
