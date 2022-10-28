//
//  PostRow.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PostRow: View {
    var post: Post
    var withDescription: Bool = true

    @MainActor var body: some View {
        HStack(alignment: .top) {
            post.user.image
                .cornerRadius(5)
                .frame(width: 70, height: 70, alignment: .leading)
                .padding(.vertical)

            VStack(alignment: .leading) {
                if withDescription {
                    Text(post.user.name)
                        .bold()
                    Text(post.text)
                } else {
                    Spacer()
                    Text(post.user.name)
                        .bold()
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var posts = PostsFactory.shared.posts

    static var previews: some View {
        Group {
            PostRow(post: posts[0])
            PostRow(post: posts[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
