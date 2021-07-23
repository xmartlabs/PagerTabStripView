//
//  AccountModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation
import Combine
import SwiftUI

class AccountModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Account", imageName: "account")
    
    var post: Post {
        let modelData = Factory()
        return modelData.posts[0]
    }
}
