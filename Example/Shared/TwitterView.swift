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
                        TabBarView(tag: item.tag, title: item.title, selection: $selection)
                    }
            }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15, tabItemHeight: 50, indicatorViewHeight: 3, indicatorView: {
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

private struct TabBarView<SelectionType: Hashable>: View {

    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: SelectionType
    let tag: SelectionType
    let title: String

    init(tag: SelectionType, title: String, selection: Binding<SelectionType>) {
        self._selection = selection
        self.tag = tag
        self.title = title
    }

    @MainActor var body: some View {
        VStack {
            let selectedColor = colorScheme == .dark ? Color.white : Color.black
            Text(title)
                .foregroundColor(Color.gray.interpolateTo(color: selection == tag ? selectedColor : Color.gray,
                                                          fraction: pagerSettings.transition.progress(for: tag)))
                .font(.subheadline.bold())
                .frame(maxHeight: .infinity)
                .animation(.default, value: selection)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(height: 40)
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
