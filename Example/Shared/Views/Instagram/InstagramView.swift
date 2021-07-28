//
//  InstagramView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//

import SwiftUI
import PagerTabStrip

struct InstagramView: View {
    
    @State var selection = 1
    
    @ObservedObject var galleryModel = GalleryModel()
    @ObservedObject var listModel = ListModel()
    @ObservedObject var likedModel = LikedModel()
    @ObservedObject var savedModel = SavedModel()
    
    var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts).pagerTabItem {
                galleryModel.navBarItem
            }.onPageAppear {
                galleryModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    galleryModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false).pagerTabItem {
                listModel.navBarItem
            }.onPageAppear {
                listModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    listModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts).pagerTabItem {
                likedModel.navBarItem
            }.onPageAppear {
                likedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    likedModel.isLoading = false
                }
            }
            
            PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false).pagerTabItem {
                savedModel.navBarItem
            }.onPageAppear {
                savedModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    savedModel.isLoading = false
                }
            }
        }
        .pagerTabStripViewStyle(PagerTabViewStyle(tabItemSpacing: 0, tabItemHeight: 50, indicatorBarColor: .black))
        .frame(alignment: .center)
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
