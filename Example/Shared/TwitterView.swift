//
//  TwitterView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

private struct DataItem: Identifiable {
    var id: String { title }
    var title: String
    var posts: [Post]
    var withDescription: Bool = true
}

struct TwitterView: View {
    @State var swipeGestureEnabled: Bool
    @State var selection = 2

    public init(swipeGestureEnabled: Bool = true) {
        self.swipeGestureEnabled = swipeGestureEnabled
    }

    private var items = [DataItem(title: "First big width", posts: TweetsModel().posts),
                  DataItem(title: "Short", posts: TweetsModel().posts),
                  DataItem(title: "Medium width", posts: TweetsModel().posts, withDescription: false),
                  DataItem(title: "Second big width", posts: TweetsModel().posts),
                  DataItem(title: "Second Medium", posts: TweetsModel().posts, withDescription: false),
                  DataItem(title: "Mini", posts: TweetsModel().posts)
    ]

    @MainActor var body: some View {
        PagerTabStripView(swipeGestureEnabled: $swipeGestureEnabled, selection: $selection) {
            ForEach(items) { item in
                PostsList(items: item.posts, withDescription: item.withDescription)
                    .pagerTabItem {
                        TwitterNavBarItem(title: item.title)
                    }
            }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15, tabItemHeight: 40, indicatorView: {
            Rectangle().fill(.blue).cornerRadius(5)
        }))
    }

}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
