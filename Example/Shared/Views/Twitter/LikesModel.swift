//
//  LikesModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class LikesModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Likes")
    
    var posts: [Post] {
        Factory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
