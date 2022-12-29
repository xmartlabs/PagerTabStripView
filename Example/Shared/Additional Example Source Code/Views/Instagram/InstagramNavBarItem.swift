//
//  InstagramNav.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramNavBarItem<SelectionType>: View where SelectionType: Hashable {
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
                .foregroundColor(selection == tag ? .blue : .gray)
        }
        .animation(.easeInOut, value: selection)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct InstagramNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        InstagramNavBarItem(imageName: "photo.stack", selection: .constant(0), tag: 0)
    }
}
