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

struct AudibleView: View {

    @State var selection = 4
    @State var toggle = true

    public init() {}

    private var items = [PageItem(tag: 1, title: "First big width", posts: TweetsModel().posts),
                         PageItem(tag: 2, title: "Short", posts: TweetsModel().posts),
                         PageItem(tag: 3, title: "Medium width", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 4, title: "Second big width", posts: TweetsModel().posts),
                         PageItem(tag: 5, title: "Second Medium", posts: TweetsModel().posts, withDescription: false),
                         PageItem(tag: 6, title: "Mini", posts: TweetsModel().posts)
    ]

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            ForEach(toggle ? items : items.reversed().dropLast(5), id: \.tag) { item in
                PostsList(items: item.posts, withDescription: item.withDescription)
                    .pagerTabItem(tag: item.tag) {
                        if selection == item.tag {
                            ZStack {
                                Text(item.title)
                                    .foregroundColor(.black)
                                    .animation(.default, value: selection)
                                    .font(.system(size: 30))
                                    .frame(maxHeight: .infinity)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            .frame(height: 40)
                        } else {
                            ZStack {
                                Text(item.title)
                                    .foregroundColor(.black)
                                    .animation(.default, value: selection)
                                    .font(.system(size: 20))
                                    .frame(maxHeight: .infinity)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                            .frame(height: 40)
                        }
                    }
            }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(pagerAnimation: nil, tabItemSpacing: 15,
                                                     tabItemHeight: 60,
                                                     padding: EdgeInsets(),
                                                     barBackgroundView: { Color.white },
                                                     indicatorView: { Rectangle().frame(height: 0) }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct AudibleView_Previews: PreviewProvider {
    static var previews: some View {
        AudibleView()
    }
}
