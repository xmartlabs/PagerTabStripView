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
    
    private var content: some View {
        ForEach(items, id: \.tag) { item in
            PostsList(items: item.posts, withDescription: item.withDescription)
                .onAppear {
                    print("Debug -> Appear: \(item.tag)")
                }
                .onDisappear {
                    print("Debug -> Dissapear: \(item.tag)")
                }
        }
    }
    
    @MainActor var body: some View {
        TabView(selection: $selection) {
            content
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .named("ScrollViewCoordinateSpace")).minX)
                    }
                )
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { offset in
                    print("Debug -> selection: \(selection), offset: \(offset)")
                })
        }
        .coordinateSpace(name: "ScrollViewCoordinateSpace")
        .tabViewStyle(PageTabViewStyle.page(indexDisplayMode: .never))
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
            let selectedColor: Color = colorScheme == .dark ? .white : .black
            Text(title)
                .foregroundColor(.gray.interpolateTo(color: selection == tag ? selectedColor : Color(.systemGray),
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
