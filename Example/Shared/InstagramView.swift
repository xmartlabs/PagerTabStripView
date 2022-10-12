//
//  InstagramView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramView: View {

    @State var selection = 1

    @ObservedObject var galleryModel = GalleryModel()
    @ObservedObject var listModel = ListModel()
    @ObservedObject var likedModel = LikedModel()
    @ObservedObject var savedModel = SavedModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts).pagerTabItem {
                InstagramNavBarItem(imageName: "gallery")
            }.onPageAppear {
                galleryModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    galleryModel.isLoading = false
                }
            }

            PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false).pagerTabItem {
                InstagramNavBarItem(imageName: "list")
            }.onPageAppear {
                listModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    listModel.isLoading = false
                }
            }

            PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts).pagerTabItem {
                InstagramNavBarItem(imageName: "liked")
            }.onPageAppear {
                likedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likedModel.isLoading = false
                }
            }

            PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false).pagerTabItem {
                InstagramNavBarItem(imageName: "saved")
            }.onPageAppear {
                savedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    savedModel.isLoading = false
                }
            }
        }
        .pagerTabStripViewStyle(.barButton(indicatorBarColor: Color(UIColor.systemGray), tabItemHeight: 50))
        .frame(alignment: .center)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
