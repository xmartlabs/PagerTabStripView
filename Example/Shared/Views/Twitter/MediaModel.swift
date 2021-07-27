//
//  MediaModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class MediaModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Media")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
