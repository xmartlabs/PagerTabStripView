//
//  TwitterView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//

import SwiftUI
import PagerTabStrip

struct TwitterView: View {
    @State var selection = 2
    
    
    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()
    
    var body: some View {
        PagerTabStripView(selection: $selection, settings: PagerSettings(tabItemSpacing: 0, tabItemHeight: 50, indicatorBarColor: .blue)) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
                tweetsModel.navBarItem
            }.onPageAppear {
                tweetsModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    tweetsModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts).pagerTabItem {
                mediaModel.navBarItem
            }.onPageAppear {
                mediaModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    mediaModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false).pagerTabItem {
                likesModel.navBarItem
            }.onPageAppear {
                likesModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likesModel.isLoading = false
                }
            }
        }
        .frame(alignment: .center)
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
