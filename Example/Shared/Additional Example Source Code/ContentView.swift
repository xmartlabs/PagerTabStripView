//
//  ContentView.swift
//  Shared
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct ContentView: View {

    @MainActor  var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TwitterView()) {
                    VStack(alignment: .leading) {
                        Text("Twitter Style").font(.body).padding(.bottom, 1)
                        Text("Scrolleable BarButtonStyle with Label").font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }

                NavigationLink(destination: InstagramView()) {
                    VStack(alignment: .leading) {
                        Text("Instagram style").font(.body).padding(.bottom, 1)
                        Text("BarButtonStyle with Icon").font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }

                NavigationLink(destination: YoutubeView()) {
                    VStack(alignment: .leading) {
                        Text("Youtube style").font(.body).padding(.bottom, 1)
                        Text("BarButtonStyle with Label and Icon")
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
                NavigationLink(destination: PinterestView()) {
                    Text("Pinterest Style")
                        .font(.body)
                }
                NavigationLink(destination: AudibleView()) {
                    Text("Audible (amazon) Style")
                        .font(.body)
                }
                NavigationLink(destination: CustomStyleView()) {
                    VStack(alignment: .leading) {
                        Text("Custom style").font(.body).padding(.bottom, 1)
                        Text("BarButtonStyle with custom indicatorView and barBackgroundView ").font(.subheadline)
                    }
                    .padding([.top, .bottom], 2)
                }
                NavigationLink(destination: SimpleView()) {
                    Text("Custom style 2")
                        .font(.body)
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
