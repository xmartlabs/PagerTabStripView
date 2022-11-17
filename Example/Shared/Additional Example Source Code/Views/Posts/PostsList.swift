//
//  PostsList.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

struct PostsList: View {
    @Binding private var isLoading: Bool
    var items: [Post]
    var withDescription: Bool

    init(isLoading: Binding<Bool> = .constant(false), items: [Post], withDescription: Bool = true) {
        self._isLoading = isLoading
        self.items = items
        self.withDescription = withDescription
    }

    @MainActor var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    .animation(.default, value: isLoading)
                    
            }
            List {
                ForEach(items) { item in
                    NavigationLink(destination: PostDetail(post: item)) {
                        PostRow(post: item, withDescription: withDescription)
                    }
                }
            }
        }
    }
}
