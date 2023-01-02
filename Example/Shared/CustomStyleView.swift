//
//  CustomStyleView.swift
//  Example (iOS)
//
//  Created by Seyed Mojtaba Hosseini Zeidabadi on 3/11/22.
//

import SwiftUI
import PagerTabStripView

struct CustomStyleView: View {

    @State var selection = 2

    private let 🌈: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple
    ]

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {

            ForEach(🌈, id: \.self) { color in
                ZStack(alignment: .center) {
                    color
                    Text("Any custom View You like")
                }
                .pagerTabItem {
                    Capsule()
                        .frame(height: 32)
                        .padding(4)
                        .foregroundColor(color)
                }
            }
        }
        .pagerTabStripViewStyle(
            .barButton(
                placedInToolbar: false,
                pagerAnimation: .interactiveSpring(response: 0.5, dampingFraction: 1.00, blendDuration: 0.25),
                tabItemHeight: 48,
                barBackgroundView: {
                    LinearGradient(
                        colors: 🌈,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.2)
                    .rotationEffect(selection % 2 == 0 ? Angle(degrees: 0) : Angle(degrees: 180))
                },
                indicatorView: {
                    Text(selection % 2 == 0 ? "👍🏻" : "👎").offset(x: 0, y: -24)
                }
            )
        )
        .navigationTitle("🌈 Rainbow")
    }
}

struct CustomStyleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomStyleView()
    }
}
