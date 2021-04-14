//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct ContentView: View {

    let colors = [Color.blue, Color.red, Color.gray, Color.yellow, Color.green]
    let titles = ["Mile", "Chechu", "Martin", "Nico", "Manu"]
    @State var change = 4
    
    var body: some View {
        Button("change") {
            change = change == 4 ? 2 : 4
        }
        GeometryReader { proxy in
            XLPagerView(.youtube, selection: 2) {
//                Text("First")
//                    .frame(width: proxy.size.width, height: 100)
//                    .padding([.leading, .trailing], 20)
//                    .background(Color.orange)
                ForEach(0...change, id: \.self) { idx in
                    Text("Page \(idx+1)")
                        .frame(width: proxy.size.width, height: 400)
                        .background(colors[idx])
                        .pagerTabItem(title: titles[idx]) {
                            Text(titles[idx])
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
