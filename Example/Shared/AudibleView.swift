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
                        TabBarView(tag: item.tag, title: item.title, selection: $selection)
                    }
            }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(tabItemSpacing: 15,
                                                     tabItemHeight: 60,
                                                     padding: EdgeInsets(),
                                                     barBackgroundView: { Color.white },
                                                     indicatorView: { Rectangle().frame(height: 0) }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

private struct TabBarView<SelectionType: Hashable>: View {

    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @Binding var selection: SelectionType
    let tag: SelectionType
    let title: String

    init(tag: SelectionType, title: String, selection: Binding<SelectionType>) {
        self._selection = selection
        self.tag = tag
        self.title = title
    }

    @MainActor var body: some View {
            ZStack {
                Text(title)
                    .foregroundColor(.black)
                    .animation(.easeInOut, value: pagerSettings.transition)
                    .font(.system(size: Double.interpolate(a: 30, b: 15, progress: pagerSettings.transition.progress(for: tag))))
                    .frame(maxHeight: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .frame(height: 40)
    }
}

struct AudibleView_Previews: PreviewProvider {
    static var previews: some View {
        AudibleView()
    }
}

extension Double {
    static func interpolate(a: Double, b: Double, progress: Double) -> Double {
        return (a * progress) + (b * (1 - progress))
    }
}
