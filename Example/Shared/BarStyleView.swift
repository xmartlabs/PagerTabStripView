//
//  BarStyleView.swift
//  Example (iOS)
//
//  Created by Cecilia Pirotto on 12/8/21.
//

import SwiftUI
import PagerTabStripView

struct BarStyleView: View {
    @State var selection = 1

    @ObservedObject var tweetsModel = TweetsModel()
    @ObservedObject var mediaModel = MediaModel()
    @ObservedObject var likesModel = LikesModel()

    var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $tweetsModel.isLoading, items: tweetsModel.posts).pagerTabItem {
            }

            PostsList(isLoading: $mediaModel.isLoading, items: mediaModel.posts).pagerTabItem {
            }

            PostsList(isLoading: $likesModel.isLoading, items: likesModel.posts, withDescription: false).pagerTabItem {
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(.bar(indicatorBarHeight: 7, indicatorBarColor: .gray))
    }
}

struct BarStyleView_Previews: PreviewProvider {
    static var previews: some View {
        BarStyleView()
    }
}
