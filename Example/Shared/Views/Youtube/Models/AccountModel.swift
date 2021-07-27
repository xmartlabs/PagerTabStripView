//
//  AccountModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation

class AccountModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Account", imageName: "account")
    
    var post: Post {
        Factory.shared.posts[0]
    }
}
