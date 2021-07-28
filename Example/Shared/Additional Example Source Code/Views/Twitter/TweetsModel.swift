//
//  TweetsModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class TweetsModel: ObservableObject {
    var navBarItem = TwitterNavBarItem(title: "Tweets")
    
    var posts: [Post] {
        PostsFactory.shared.posts
    }
    
    @Published var isLoading: Bool = false
}
