//
//  SegmentedView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct SegmentedView: View {
    @State var toggle = true
    @State var selection = 1

    @StateObject var tweetsModel = TweetsModel()
    @StateObject var mediaModel = TweetsModel()
    @StateObject var likesModel = TweetsModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts)
                .pagerTabItem(tag: 0) {
                    Text("Tweets")
                }
            if toggle {
                PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts)
                    .pagerTabItem(tag: 1) {
                        Text("Media")
                    }
            }
            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false)
                .pagerTabItem(tag: 2) {
                    Text("Likes")
                }
        }
        .pagerTabStripViewStyle(.segmentedControl(placedInToolbar: false,
                                                  backgroundColor: .yellow,
                                                  padding: EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20)))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
