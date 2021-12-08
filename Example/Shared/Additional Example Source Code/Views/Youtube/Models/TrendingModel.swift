//
//  TrendingModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class TrendingModel: ObservableObject {

    var posts: [Post] {
        PostsFactory.shared.posts
    }

    @Published var isLoading: Bool = false
}
