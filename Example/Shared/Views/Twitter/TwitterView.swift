//
//  TwitterView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//
import SwiftUI
import PagerTabStrip

struct TwitterView: View {
    let titles = [TwitterNavBarItem(title: "Tweets"),
                  TwitterNavBarItem(title: "Media"),
                  TwitterNavBarItem(title: "Likes")]
    
    var body: some View {
        XLPagerView(selection: 0, pagerSettings: PagerSettings(tabItemSpacing: 0, tabItemHeight: 50)) {
            ForEach(0...2, id: \.self) { idx in
//                PostsList().pagerTabItem {
//                    titles[idx]
//                }
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
