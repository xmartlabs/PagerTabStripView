//
//  SavedModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class SavedModel: ObservableObject {

    var posts: [Post] {
        PostsFactory.shared.posts
    }

    @Published var isLoading: Bool = false
}
