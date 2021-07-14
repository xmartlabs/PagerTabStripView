//
//  PostDetail.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/5/21.
//
import SwiftUI

struct PostDetail: View {
    @EnvironmentObject var modelData: ModelData
    var post: Post
    
    var postIndex: Int {
        modelData.posts.firstIndex(where: { $0.id == post.id })!
    }
    
    var body: some View {
        ScrollView {
            post.user.image
                .frame(width: 100.0, height: 100.0)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
                .padding(.top, 100)
            
            VStack(alignment: .center) {
                Text(post.user.name)
                    .font(.title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(post.text)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(post: ModelData().posts[0])
    }
}
