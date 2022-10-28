//
//  BarStyleView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct BarStyleView: View {
    @State var selection = 1

    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
            }

            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts).pagerTabItem {
            }

            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false).pagerTabItem {
            }
        }
        .pagerTabStripViewStyle(.bar(placedInToolbar: false, indicatorViewHeight: 6) { Rectangle().fill(.yellow) })
        .navigationTitle("Bar Style View")
    }
}

struct BarStyleView_Previews: PreviewProvider {
    static var previews: some View {
        BarStyleView()
    }
}
