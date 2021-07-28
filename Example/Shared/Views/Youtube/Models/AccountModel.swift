//
//  AccountModel.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

class AccountModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Account", imageName: "account")
    
    var post: Post {
        PostsFactory.shared.posts[0]
    }
}
