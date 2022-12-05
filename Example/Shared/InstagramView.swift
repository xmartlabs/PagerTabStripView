//
//  InstagramView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramView: View {

    enum Page {
        case gallery
        case list
        case like
        case saved
    }

    @State var selection = Page.list
    @State var toggle = true

    @StateObject var galleryModel = GalleryModel()
    @StateObject var listModel = ListModel()
    @StateObject var likedModel = LikedModel()
    @StateObject var savedModel = SavedModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts)
                .pagerTabItem(tag: Page.gallery) {
                    InstagramNavBarItem(imageName: "gallery", selection: $selection, tag: Page.gallery)
                }
                .onAppear {
                    galleryModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        galleryModel.isLoading = false
                    }
                }
            PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false)
                .pagerTabItem(tag: Page.list) {
                    InstagramNavBarItem(imageName: "list", selection: $selection, tag: Page.list)
                }
                .onAppear {
                    listModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        listModel.isLoading = false
                    }
                }
            if toggle {
                    PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts)
                        .pagerTabItem(tag: Page.like) {
                            InstagramNavBarItem(imageName: "liked", selection: $selection, tag: Page.like)
                        }.onAppear {
                            likedModel.isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                likedModel.isLoading = false
                            }
                        }
                    PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false)
                    .pagerTabItem(tag: Page.saved) {
                        InstagramNavBarItem(imageName: "saved", selection: $selection, tag: Page.saved)
                    }.onAppear {
                        savedModel.isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            savedModel.isLoading = false
                        }
                    }
            }
        }
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false, pagerAnimation: .default,
                                           tabItemHeight: 50, indicatorViewHeight: 2, indicatorView: {
            Rectangle().fill(.blue).cornerRadius(1)
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
