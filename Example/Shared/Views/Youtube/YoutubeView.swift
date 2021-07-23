//
//  YoutubeView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//
import SwiftUI
import PagerTabStrip

struct YoutubeView: View {
    @ObservedObject var homeModel = HomeModel()
    @ObservedObject var trendingModel = TrendingModel()
    @ObservedObject var accountModel = AccountModel()
    
    var body: some View {
        XLPagerView(selection: 0, pagerSettings: PagerSettings(tabItemSpacing: 0, tabItemHeight: 70)) {
            PostsList(isLoading: $homeModel.isLoading, items: homeModel.posts).pagerTabItem {
                homeModel.navBarItem
            }.onPageAppear {
                homeModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    homeModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $trendingModel.isLoading, items: trendingModel.posts, withDescription: false).pagerTabItem {
                trendingModel.navBarItem
            }.onPageAppear {
                trendingModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    trendingModel.isLoading = false
                }
            }
            
            PostDetail(post: accountModel.post).pagerTabItem {
                accountModel.navBarItem
            }
        }
        .frame(alignment: .center)
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView()
    }
}
