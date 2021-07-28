//
//  MediaModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class MediaModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Media")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
