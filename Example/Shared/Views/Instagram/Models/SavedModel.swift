//
//  SavedModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class SavedModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "saved")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
