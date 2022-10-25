//
//  SegmentedView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

        


import SwiftUI
import PagerTabStripView

struct SegmentedView: View {
    @State var selection = 2

    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts)
                .pagerTabItem {
                    Text("Tweets")
                }
            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts)
                .pagerTabItem {
                    Text("Media")
                }
            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false)
                .pagerTabItem {
                    Text("Likes")
                }
        }
        .pagerTabStripViewStyle(.segmentedControl(backgroundColor: .yellow,
                                                  placedInToolbar: true))
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
