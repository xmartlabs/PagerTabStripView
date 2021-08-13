//
//  TwitterView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct TwitterView: View {
    @State var selection = 2
    
    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()
    
    var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
                TwitterNavBarItem(title: "Tweets")
            }.onPageAppear {
                tweetsModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    tweetsModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts).pagerTabItem {
                TwitterNavBarItem(title: "Media")
            }.onPageAppear {
                mediaModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    mediaModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false).pagerTabItem {
                TwitterNavBarItem(title: "Likes")
            }.onPageAppear {
                likesModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likesModel.isLoading = false
                }
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(.normal(indicatorBarColor: .blue, tabItemSpacing: 0, tabItemHeight: 50))
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
