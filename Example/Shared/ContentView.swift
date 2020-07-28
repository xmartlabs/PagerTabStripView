//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct ContentView: View {
    
    @State var index: Int = 3
    
    var body: some View {
        XLPagerView(.youtube, selection: $index) {
            Text("First")
            ForEach(1...5, id: \.self) { idx in
                Text("Page \(idx)")
            }
            Text("Last")
        }
        .frame(alignment: .center)
        Text("Page \(index) of 7")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
