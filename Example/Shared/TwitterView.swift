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
    @ObservedObject var tweetsModel2 = TweetsModel()
    @ObservedObject var mediaModel2 = MediaModel()
    @ObservedObject var likesModel2 = LikesModel()
    
    var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
                TwitterNavBarItem(title: "Tweets Tweets Tweets")
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
                TwitterNavBarItem(title: "Likes Likes")
            }.onPageAppear {
                likesModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likesModel.isLoading = false
                }
            }

            PostsList(isLoading: $tweetsModel2.isLoading, items: tweetsModel2.posts).pagerTabItem {
                TwitterNavBarItem(title: "Tweets Tweets Tweets")
            }.onPageAppear {
                tweetsModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    tweetsModel.isLoading = false
                }
            }

            PostsList(isLoading: $mediaModel2.isLoading, items: mediaModel2.posts).pagerTabItem {
                TwitterNavBarItem(title: "Media")
            }.onPageAppear {
                mediaModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    mediaModel.isLoading = false
                }
            }

            PostsList(isLoading: $likesModel2.isLoading, items: likesModel2.posts, withDescription: false).pagerTabItem {
                TwitterNavBarItem(title: "Likes Likes")
            }.onPageAppear {
                likesModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likesModel.isLoading = false
                }
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(.scrollableBarButton(indicatorBarColor: .blue, tabItemSpacing: 15, tabItemHeight: 50))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
