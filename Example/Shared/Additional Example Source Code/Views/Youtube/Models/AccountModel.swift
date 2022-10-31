//
//  AccountModel.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation

class AccountModel: ObservableObject {

    var post: Post {
        PostsFactory.shared.posts[0]
    }
}
