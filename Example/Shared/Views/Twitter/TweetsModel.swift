//
//  TweetsModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 24/7/21.
//

import Foundation

class TweetsModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Tweets")
    
    var posts: [Post] {
        Factory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
