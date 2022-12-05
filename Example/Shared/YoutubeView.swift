//
//  YoutubeView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct YoutubeView: View {

    @StateObject var homeModel = HomeModel()
    @StateObject var trendingModel = HomeModel()
    @StateObject var accountModel = AccountModel()

    @State var selection = 1

    @State var toggle: Bool = false

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $homeModel.isLoading, items: homeModel.posts)
                .pagerTabItem(tag: 0) {
                    YoutubeNavBarItem(title: "Home", imageName: "home", selection: $selection, tag: 0)
                }.onAppear {
                    homeModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        homeModel.isLoading = false
                    }
                }

            PostsList(isLoading: $trendingModel.isLoading, items: trendingModel.posts, withDescription: false)
                .pagerTabItem(tag: 1) {
                    YoutubeNavBarItem(title: "Trending", imageName: "trending", selection: $selection, tag: 1)
                }
                .onAppear {
                    trendingModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        trendingModel.isLoading = false
                    }
                }
            if toggle {
                PostDetail(post: accountModel.post)
                    .pagerTabItem(tag: 2) {
                        YoutubeNavBarItem(title: "Account", imageName: "account", selection: $selection, tag: 2)
                    }
            }
        }
        .pagerTabStripViewStyle(.barButton(tabItemHeight: 80, padding: EdgeInsets(), indicatorViewHeight: 5, barBackgroundView: {
                                                Color(red: 221/255.0, green: 0/255.0, blue: 19/255.0, opacity: 1.0)
                                           },
                                           indicatorView: {
                                            Rectangle().fill(selectedColor)
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
