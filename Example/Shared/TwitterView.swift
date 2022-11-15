//
//  TwitterView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

private struct PageItem: Identifiable {
    var id: Int { tag }
    var tag: Int
    var title: String
    var posts: [Post]
    var withDescription: Bool = true
}

struct TwitterView: View {
    @State var swipeGestureEnabled: Bool
    @State var selection = 2
    @State var toggle = true

    public init(swipeGestureEnabled: Bool = true) {
        self.swipeGestureEnabled = swipeGestureEnabled
    }

    private var items = [PageItem(tag: 1, title: "First big width", posts: TweetsModel().posts),
                         PageItem(tag: 2, title: "Short", posts: TweetsModel().posts),
                         PageItem(tag: 3, title: "Medium width", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 4, title: "Second big width", posts: TweetsModel().posts),
                         PageItem(tag: 5, title: "Second Medium", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 6, title: "Mini", posts: TweetsModel().posts)
    ]

    @MainActor var body: some View {
       // PagerTabStripView(swipeGestureEnabled: $swipeGestureEnabled, selection: $selection) {
        TabView(selection: $selection) {
            ForEach(toggle ? items : items.dropLast(5), id: \.title) { item in
                PostsList(items: item.posts, withDescription: item.withDescription)
                    .colorMultiply(Color.red)
                    .tabItem {
                        Text(item.title)
                    }.tag(item.tag)
                //                    .pagerTabItem(tag: item.tag) {
                //                        TwitterNavBarItem(title: item.title)
                //                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
//        }
//        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15, tabItemHeight: 40, indicatorView: {
//            Rectangle().fill(.blue).cornerRadius(5)
//        }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
