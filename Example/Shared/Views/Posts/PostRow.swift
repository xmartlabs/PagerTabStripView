//
//  PostRow.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import SwiftUI

struct PostRow: View {
    var post: Post

    var body: some View {
        HStack (alignment: .top){
            post.user.image
                .resizable()
                .frame(width: 70, height: 70, alignment: .leading)
                .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text(post.user.name)
                    .bold()
                Text(post.text)
            }
            .padding()
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var posts = ModelData().posts
    
    static var previews: some View {
        Group {
            PostRow(post: posts[0])
            PostRow(post: posts[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
