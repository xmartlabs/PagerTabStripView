//
//  YoutubeView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct YoutubeView: View {

    @ObservedObject var homeModel = HomeModel()
    @ObservedObject var trendingModel = TrendingModel()
    @ObservedObject var accountModel = AccountModel()

    @MainActor var body: some View {
        PagerTabStripView {
            PostsList(isLoading: $homeModel.isLoading, items: homeModel.posts).pagerTabItem {
                YoutubeNavBarItem(title: "Home", imageName: "home")
            }.onPageAppear {
                homeModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    homeModel.isLoading = false
                }
            }

            PostsList(isLoading: $trendingModel.isLoading, items: trendingModel.posts,
                      withDescription: false).pagerTabItem {
                YoutubeNavBarItem(title: "Trending", imageName: "trending")
            }
            .onPageAppear {
                trendingModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    trendingModel.isLoading = false
                }
            }

            PostDetail(post: accountModel.post).pagerTabItem {
                YoutubeNavBarItem(title: "Account", imageName: "account")
            }
        }
        .pagerTabStripViewStyle(.barButton(indicatorBarHeight: 5, indicatorBarColor: selectedColor, tabItemHeight: 80))
        .frame(alignment: .center)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView()
    }
}
