//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct MyNavItem: View, Equatable {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(.blue)
            Text(subtitle)
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
    }

    static func ==(lhs: MyNavItem, rhs: MyNavItem) -> Bool {
        return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
    }
}

struct ContentView: View {

    let colors = [Color.blue, Color.red, Color.gray, Color.yellow, Color.green]
    let titlesIG = [InstagramNav(title: "FOLLOWING"),
                  InstagramNav(title: "YOU")]
    let titles = [YoutubeNavWithTitle(title: "Home", imageName: "home"),
                  YoutubeNavWithTitle(title: "Trending", imageName: "trending"),
                  YoutubeNavWithTitle(title: "Account", imageName: "account")]
    
   // @State var change = 4
    @State var index = 0
    
    var body: some View {
//        Button("change") {
//            change = change == 4 ? 2 : 4
//        }
        GeometryReader { proxy in
            XLPagerView(.youtube, selection: 0, currentIndex: $index, pagerSettings: PagerSettings(height: 700, tabItemSpacing: 0, tabItemHeight: 50)) {
                ForEach(0...titles.count - 1, id: \.self) { idx in
                    
                    PostsList().pagerTabItem {
                        titles[idx]
                    }
//                        Text("Page \(idx+1)")
//                            .background(colors[idx])
//                            .pagerTabItem {
//                                titles[idx]
//                            }
//                        }
//                        .background(Color.purple)
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
