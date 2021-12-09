//
//  ContentView.swift
//  Shared
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct ContentView: View {

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TwitterView()) {
                    VStack(alignment: .leading) {
                        Text("Scrollable style")
                            .font(.body)
                            .padding(.bottom, 1)
                        Text("Only label")
                            .font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }

                NavigationLink(destination: InstagramView()) {
                    VStack(alignment: .leading) {
                        Text("Normal style")
                            .font(.body)
                            .padding(.bottom, 1)
                        Text("Only icon")
                            .font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }

                NavigationLink(destination: YoutubeView()) {
                    VStack(alignment: .leading) {
                        Text("Normal style")
                            .font(.body)
                            .padding(.bottom, 1)
                        Text("Label and icon")
                            .font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }
                NavigationLink(destination: SegmentedView()) {
                    Text("Segmented style")
                        .font(.body)
                }
                NavigationLink(destination: BarStyleView()) {
                    Text("Bar style")
                        .font(.body)
                }
                NavigationLink(destination: TwitterView(swipeGestureEnabled: false)) {
                    VStack(alignment: .leading) {
                        Text("Scrollable style, swipe disabled")
                            .font(.body)
                            .padding(.bottom, 1)
                        Text("Only label")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
