//
//  HomeModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class HomeModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Home", imageName: "home")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
