//
//  TrendingModel.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 23/7/21.
//

import Foundation
import Combine
import SwiftUI

class TrendingModel: ObservableObject {
    var navBarItem = YoutubeNavBarItem(title: "Trending", imageName: "trending")
    
    var posts: [Post] {
        let modelData = Factory()
        return modelData.posts
    }
    
    @Published var isLoading: Bool = false
}
