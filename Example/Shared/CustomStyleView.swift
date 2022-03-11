//
//  CustomStyleView.swift
//  Example (iOS)
//
//  Created by Seyed Mojtaba Hosseini Zeidabadi on 3/11/22.
//

import SwiftUI
import PagerTabStripView

struct CustomStyleView: View {

    private let 🌈: [Color] = [.purple, .blue, .green, .yellow, .orange, .red]

    var body: some View {
        PagerTabStripView {

            ForEach(🌈, id: \.self) { color in
                ZStack(alignment: .center) {
                    color
                    Text("Any custom View You like")
                }
                .pagerTabItem() {
                    Capsule()
                        .frame(height: 32)
                        .padding(4)
                        .foregroundColor(color)
                }
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(
            .custom(
                tabItemHeight: 48,
                indicator: {
                    .init(
                        Text("👍🏻")
                            .offset(x: 0, y: -24)
                    )
                },
                background: {
                    .init(
                        LinearGradient(
                            colors: 🌈,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                            .opacity(0.2)
                    )
                }
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("🌈 Rainbow")
    }
}

struct CustomStyleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomStyleView()
    }
}
