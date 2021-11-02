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
            TabView {
                InstagramView().tabItem {Text("InstagramView").maxWidth()}.hideNavigationBar()
                TwitterView().tabItem {Text("TwitterView").maxWidth()}.hideNavigationBar()
                YoutubeView().tabItem {Text("YoutubeView").maxWidth()}.hideNavigationBar()
                SegmentedView().tabItem {Text("SegmentedView").maxWidth()}.hideNavigationBar()
                BarStyleView().tabItem {Text("BarStyleView").maxWidth()}.hideNavigationBar()
            }
        }
    }
}

extension View {
    
    func hideNavigationBar() -> some View {
        self
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
    
    func maxWidth(alignment: Alignment = .center) -> some View {
        self.frame(minWidth: .zero, idealWidth: .infinity, maxWidth: .infinity, alignment: alignment)
    }
}
