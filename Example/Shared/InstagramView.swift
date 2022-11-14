//
//  InstagramView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramView: View {

    @State var selection = 1
    @State var toggle = false

    @ObservedObject var galleryModel = GalleryModel()
    @ObservedObject var listModel = ListModel()
    @ObservedObject var likedModel = LikedModel()
    @ObservedObject var savedModel = SavedModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            if toggle {
                PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts).pagerTabItem(tag: 0) {
                    InstagramNavBarItem(imageName: "gallery")
                }
                .onAppear {
                    galleryModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        galleryModel.isLoading = false
                    }
                }
                PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false).pagerTabItem(tag: 1) {
                    InstagramNavBarItem(imageName: "list")
                }
                .onAppear {
                    listModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        listModel.isLoading = false
                    }
                }
            }
            PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts).pagerTabItem(tag: 2) {
                InstagramNavBarItem(imageName: "liked")
            }.onAppear {
                likedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likedModel.isLoading = false
                }
            }
            PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false).pagerTabItem(tag: 3) {
                InstagramNavBarItem(imageName: "saved")
            }.onAppear {
                savedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    savedModel.isLoading = false
                }
            }
        }
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false, pagerAnimation: .default, tabItemHeight: 50, indicatorView: {
            Rectangle().fill(Color(.systemGray))
        }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
