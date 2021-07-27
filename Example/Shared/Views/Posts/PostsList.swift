//
//  PostsList.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import Foundation
import SwiftUI

struct PostsList: View {
    @Binding private var isLoading: Bool
    var items: [Post]
    var withDescription: Bool
    
    init(isLoading: Binding<Bool>, items: [Post], withDescription: Bool = true) {
        self._isLoading = isLoading
        self.items = items
        self.withDescription = withDescription
    }
    
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            }
            List {
                ForEach(items) { item in
                    PostRow(post: item, withDescription: withDescription)
                }
            }
        }
        .animation(.default, value: isLoading)
        
    }
}
