//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

typealias MyPagerView<T: View> = XLPagerView<T, MyNavItem>

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

//var 

struct ContentView: View {

    let colors = [Color.blue, Color.red, Color.gray, Color.yellow, Color.green]
    let titles = [MyNavItem(title: "Mile", subtitle: "Dev"),
                  MyNavItem(title: "Chechu", subtitle: "Dev"),
                  MyNavItem(title: "Martin", subtitle: "Marketing"),
                  MyNavItem(title: "Nico", subtitle: "Dev"),
                  MyNavItem(title: "Manu", subtitle: "Dev")]

//    let pagerSettings = PagerStyleSettings(width: proxy.size.width, height: 400, navBarSettings: NavBarStyleSettings(tabItemSpacing: 10, height: 50))

    @State var change = 4
    
    var body: some View {
        Button("change") {
            change = change == 4 ? 2 : 4
        }
        GeometryReader { proxy in
            MyPagerView(.youtube, selection: 2, size: CGSize(width: 300, height: 400), pagerSettings: PagerStyleSettings(width: proxy.size.width, height: 400, navBarSettings: NavBarStyleSettings(tabItemSpacing: 10, height: 50))) {

                ForEach(0...change, id: \.self) { idx in
                    Text("Page \(idx+1)")
                        .background(colors[idx])
                        .pagerTabItem {
                            titles[idx]
                        }
                }
//                Text("Last")
//                    .frame(width: proxy.size.width, height: 100)
                    .background(Color.purple)
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
