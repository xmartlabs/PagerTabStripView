//
//  LikesModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class LikesModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Likes")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
