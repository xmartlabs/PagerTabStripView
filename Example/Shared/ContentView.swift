//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStrip

struct ContentView: View {
    
    var body: some View {
        XLPagerView(.youtube) {
            Text("First")
            ForEach(1...5, id: \.self) { idx in
                Text("Page \(idx)")
            }
            Text("Last")
        }
        .frame(alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
