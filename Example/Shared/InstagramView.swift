//
//  InstagramView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramView: View {

    enum Page: String {
        case gallery = "photo.stack"
        case list  = ""
        case like
        case saved
    }

    @State var selection = Page.list
    @State var toggle = true

    @StateObject var galleryModel = ListModel()
    @StateObject var listModel = ListModel()
    @StateObject var likedModel = ListModel()
    @StateObject var savedModel = ListModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts)
                .pagerTabItem(tag: Page.gallery) {
                    InstagramNavBarItem(imageName: "photo.stack", selection: $selection, tag: Page.gallery)
                }
            PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false)
                .pagerTabItem(tag: Page.list) {
                    InstagramNavBarItem(imageName: "chart.bar.doc.horizontal" /* "list.bullet" */, selection: $selection, tag: Page.list)
                }
            if toggle {
                PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts)
                    .pagerTabItem(tag: Page.like) {
                        InstagramNavBarItem(imageName: "heart", selection: $selection, tag: Page.like)
                    }
                PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false)
                    .pagerTabItem(tag: Page.saved) {
                        InstagramNavBarItem(imageName: "photo.stack" /* "bookmark"*/, selection: $selection, tag: Page.saved)
                    }
            }
        }
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false,
                                           tabItemHeight: 50, indicatorViewHeight: 2,
                                           indicatorView: { Rectangle().fill(Color(.systemBlue)).cornerRadius(1) }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct InstagramNavBarItem<SelectionType>: View where SelectionType: Hashable {
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>

    var image: Image
    @Binding var selection: SelectionType
    let tag: SelectionType

    init(imageName: String, selection: Binding<SelectionType>, tag: SelectionType) {
        self.tag = tag
        self.image = Image(systemName: imageName)
        _selection = selection
    }

    @MainActor var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 25.0, height: 25)
                .foregroundColor(Color(.systemGray).interpolateTo(color: Color(.systemBlue), fraction: pagerSettings.transition.progress(for: tag)))
        }
        .animation(.easeInOut, value: selection)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
