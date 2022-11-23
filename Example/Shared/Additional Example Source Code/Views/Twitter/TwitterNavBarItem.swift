//
//  TwitterNav.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct TwitterNavBarItem<SelectionType>: View where SelectionType: Hashable {
    let title: String
    @Binding var selection: SelectionType
    let tag: SelectionType

    public init(title: String, selection: Binding<SelectionType>, tag: SelectionType) {
        self.title = title
        self.tag = tag
        _selection = selection
    }

    @State private var color = Color.gray

    @MainActor var body: some View {
        VStack {
            Text(title)
                .foregroundColor(selection == tag ? .blue : .gray)
                .font(.subheadline)
                .frame(maxHeight: .infinity)
                .animation(.default, value: selection)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(height: 40)
    }
}

struct TwitterNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        TwitterNavBarItem(title: "Tweets", selection: .constant(0), tag: 0)
    }
}
