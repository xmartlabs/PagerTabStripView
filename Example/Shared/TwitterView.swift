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
    @State var selection = 4
    @State var toggle = true
    @State var swipeGestureEnabled = true

    private var items = [PageItem(tag: 1, title: "First big width", posts: TweetsModel().posts),
                         PageItem(tag: 2, title: "Short", posts: TweetsModel().posts),
                         PageItem(tag: 3, title: "Medium width", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 4, title: "Second big width", posts: TweetsModel().posts),
                         PageItem(tag: 5, title: "Second Medium", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 6, title: "Mini", posts: TweetsModel().posts)
    ]

    @MainActor var body: some View {
        PagerTabStripView(swipeGestureEnabled: $swipeGestureEnabled, selection: $selection) {
            ForEach(toggle ? items : items.reversed().dropLast(5), id: \.title) { item in
                PostsList(items: item.posts, withDescription: item.withDescription)
                    .pagerTabItem(tag: item.tag) {
                        VStack {
                            Text(item.title)
                                .foregroundColor(selection == item.tag ? .blue : .gray)
                                .font(.subheadline)
                                .frame(maxHeight: .infinity)
                                .animation(.default, value: selection)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                        .frame(height: 40)
                    }
            }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15, tabItemHeight: 40, indicatorView: {
            Rectangle().fill(.blue).cornerRadius(5)
        }))
        .navigationBarItems(trailing: HStack {
                                        Button("Refresh") {
                                            toggle.toggle()
                                        }
                                        Button(swipeGestureEnabled ? "Swipe On": "Swipe Off") {
                                            swipeGestureEnabled.toggle()
                                        }
                                    }
            )
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
