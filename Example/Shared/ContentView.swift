//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct MyNavItem: View, PagerTabViewDelegate, Equatable {
    let title: String
    let subtitle: String

    @State var textColor = Color.gray

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(textColor)
            Text(subtitle)
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
    }

    static func ==(lhs: MyNavItem, rhs: MyNavItem) -> Bool {
        return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
    }

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            textColor = .blue
        default:
            textColor = .gray
        }
    }
}

struct ContentView: View {

    let colors = [Color.blue, Color.red, Color.gray, Color.yellow, Color.green]
    let titlesIG = [InstagramNav(title: "FOLLOWING"),
                  InstagramNav(title: "YOU")]
    let titles = [YoutubeNavWithTitle(title: "Home", imageName: "home"),
                  YoutubeNavWithTitle(title: "Trending", imageName: "trending"),
                  YoutubeNavWithTitle(title: "Account", imageName: "account")]
    
    @State var change = 2
    @State var index = 0
    
    var body: some View {
        Button("change") {
            change = change == 2 ? 1 : 2
        }
        GeometryReader { proxy in
            XLPagerView(.youtube, selection: 2, pagerSettings: PagerSettings(height: 500, tabItemSpacing: 0, tabItemHeight: 50)) {
                ForEach(0...change, id: \.self) { idx in
                    PostsList().pagerTabItem {
                        titles[idx]
                    }
                }
            }
            .frame(alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
