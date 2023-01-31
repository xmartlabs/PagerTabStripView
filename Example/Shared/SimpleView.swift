//
//  SimpleVIew.swift
//  Example (iOS)
//
//  Created by Martin Barreto on 24/11/22.
//

import SwiftUI
import PagerTabStripView

struct SimpleView: View {

    let textForColor = [Color.purple: "Swiftable 2022",
                        .green: "SwiftUI",
                        .yellow: "iOS 16.1",
                        .orange: "PagerTabStripView"]
    let colors = [Color.purple, .green, .yellow, .orange]
    @State var selection: Color = .green

    var body: some View {
        PagerTabStripView(selection: $selection) {
            ForEach(colors, id: \.self) { color in
                Rectangle()
                    .fill(color.gradient)
                    .pagerTabItem(tag: color) {
                        Text(textForColor[color]!)
                            .foregroundColor(color)
                    }
            }
        }
        .pagerTabStripViewStyle(
            .scrollableBarButton(tabItemSpacing: 25,
                                 tabItemHeight: 50,
                                 indicatorViewHeight: 13,
                                 indicatorView: {
                                    Circle()
                                        .offset(y: -5)
                                        .foregroundColor(selection)
                                        .animation(.linear(duration: 0.5)
                                                    .repeatForever(autoreverses: true),
                                                   value: selection)
                                 }))
    }

}

struct SimpleView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleView()
    }
}
