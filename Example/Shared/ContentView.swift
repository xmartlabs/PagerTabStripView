//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct MyNavItem: View, PagerTabViewProtocol, Equatable {
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
    let titles = [MyNavItem(title: "Mile", subtitle: "Dev"),
                  MyNavItem(title: "Chechu", subtitle: "Dev"),
                  MyNavItem(title: "Martin", subtitle: "Marketing"),
                  MyNavItem(title: "Nico", subtitle: "Dev"),
                  MyNavItem(title: "Manu", subtitle: "Dev")]
    
    @State var change = 4
    
    var body: some View {
        Button("change") {
            change = change == 4 ? 2 : 4
        }
        GeometryReader { proxy in
            XLPagerView(.youtube, selection: 2, pagerSettings: PagerSettings(height: 400, tabItemSpacing: 10, tabItemHeight: 50)) {
                ForEach(0...change, id: \.self) { idx in
                        Text("Page \(idx+1)")
                            .background(colors[idx])
                            .pagerTabItem {
                                titles[idx]
                            }
                        }
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
