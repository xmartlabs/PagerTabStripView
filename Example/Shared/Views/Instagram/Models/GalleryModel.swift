//
//  GalleryModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class GalleryModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "gallery")
    
    var posts: [Post] {
        Factory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
