//
//  HomeModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation

class HomeModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Home", imageName: "home")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
