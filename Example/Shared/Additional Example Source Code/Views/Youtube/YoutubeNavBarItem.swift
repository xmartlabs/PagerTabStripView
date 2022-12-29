//
//  YoutubeNavWithTitle.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

let unselectedColor = Color(red: 73/255.0, green: 8/255.0, blue: 10/255.0, opacity: 1.0)
let selectedColor = Color(red: 234/255.0, green: 234/255.0, blue: 234/255.0, opacity: 0.7)

struct YoutubeNavBarItem<SelectedType>: View where SelectedType: Hashable {
    let title: String
    let image: Image
    @Binding var selection: SelectedType
    let tag: SelectedType

    init(title: String, imageName: String, selection: Binding<SelectedType>, tag: SelectedType) {
        self.tag = tag
        self.title = title
        self.image = Image(systemName: imageName)
        _selection = selection
    }

    @MainActor var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(selection == tag ? selectedColor : unselectedColor)
            Text(title.uppercased())
                .foregroundColor(selection == tag ? selectedColor : unselectedColor)
                .fontWeight(.semibold)
        }
        .animation(.default, value: selection)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct YoutubeNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeNavBarItem(title: "Home", imageName: "house", selection: .constant(0), tag: 0)
    }
}
