//
//  HomeModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation
import Combine
import SwiftUI

class HomeModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Home", imageName: "home")
    
    var posts: [Post] {
        let modelData = Factory()
        return modelData.posts
    }
    
    @Published var isLoading: Bool = false
}
