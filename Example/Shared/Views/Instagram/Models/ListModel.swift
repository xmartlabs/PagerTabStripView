//
//  ListModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class ListModel: ObservableObject {
    var navBarItem = InstagramNavBarItem(imageName: "list")
    
    var posts: [Post] {
        Factory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
