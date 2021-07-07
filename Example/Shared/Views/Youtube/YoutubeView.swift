//
//  YoutubeView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//
import SwiftUI
import PagerTabStrip

struct YoutubeView: View {
    
    let titles = [YoutubeNavBarItem(title: "Home", imageName: "home"),
                  YoutubeNavBarItem(title: "Trending", imageName: "trending"),
                  YoutubeNavBarItem(title: "Account", imageName: "account")]
    
    var body: some View {
        XLPagerView(selection: 0, pagerSettings: PagerSettings(tabItemSpacing: 0, tabItemHeight: 70)) {
            ForEach(0...2, id: \.self) { idx in
                PostsList().pagerTabItem {
                    titles[idx]
                }
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
