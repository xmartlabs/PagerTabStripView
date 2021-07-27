//
//  TrendingModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation

class TrendingModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Trending", imageName: "trending")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
