//
//  SegmentedView.swift
//  Example (iOS)
//
//  Created by Cecilia Pirotto on 12/8/21.
//

import SwiftUI
import PagerTabStripView

struct SegmentedView: View {
    @State var selection = 2

    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()

    var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
                Text("Tweets")
            }

            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts).pagerTabItem {
                Text("Media")
            }

            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false).pagerTabItem {
                Text("Likes")
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(PagerTabViewStyle(tabItemSpacing: 0, indicatorBarColor: .blue, style: .segmentedControl(backgroundColor: .yellow, padding: EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))))
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView()
    }
}
