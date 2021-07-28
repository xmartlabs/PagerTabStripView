//
//  GalleryModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class GalleryModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "gallery")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
