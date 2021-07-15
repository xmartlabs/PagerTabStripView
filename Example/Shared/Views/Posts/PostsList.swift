//
//  PostsList.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//
import Foundation
import SwiftUI

struct PostsList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @Binding private var isLoading: Bool
    
    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }
    
    var posts: [Post] {
        modelData.posts
    }
    
    
    var body: some View {
        if isLoading {
            ProgressView()
        } else {
            List {
                ForEach(posts) { post in
                    PostRow(post: post)
                }
            }
        }
        
    }
}
