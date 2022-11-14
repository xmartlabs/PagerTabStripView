//
//  YoutubeView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct YoutubeView: View {

    @ObservedObject var homeModel = HomeModel()
    @ObservedObject var trendingModel = HomeModel()
    @ObservedObject var accountModel = AccountModel()

    @State var toggle: Bool = false

    @MainActor var body: some View {
        PagerTabStripView {
            PostsList(isLoading: $homeModel.isLoading, items: homeModel.posts)
                .pagerTabItem(tag: 0) {
                    YoutubeNavBarItem(title: "Home", imageName: "home")
                }.onAppear {
                    homeModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        homeModel.isLoading = false
                    }
                }

            PostsList(isLoading: $trendingModel.isLoading, items: trendingModel.posts, withDescription: false)
                .pagerTabItem(tag: 1) {
                    YoutubeNavBarItem(title: "Trending", imageName: "trending")
                }
                .onAppear {
                    trendingModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        trendingModel.isLoading = false
                    }
                }
            if toggle {
                PostDetail(post: accountModel.post).pagerTabItem(tag: 2) {
                    YoutubeNavBarItem(title: "Account", imageName: "account")
                }
            }
        }
        .pagerTabStripViewStyle(.barButton(tabItemHeight: 80, indicatorViewHeight: 5, indicatorView: {
            Rectangle().fill(selectedColor).offset(x: 0, y: -5)
        }))
        .navigationBarItems(trailing: Button(toggle ? "Hide Pofile" : "Show Profile") {
            toggle.toggle()
        })
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView()
    }
}
