//
//  PostDetail.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PostDetail: View {
    var post: Post

    @MainActor var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .center) {
                post.user.image
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                    .padding(.top, 100)
                Spacer()
                Text(post.user.name)
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
                Text(post.text)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame( maxWidth: .infinity)
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(post: PostsFactory.shared.posts[0])
    }
}
