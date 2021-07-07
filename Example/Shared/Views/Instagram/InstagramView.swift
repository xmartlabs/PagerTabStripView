//
//  InstagramView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//
import SwiftUI
import PagerTabStrip

struct InstagramView: View {
    let titles = [InstagramNav(imageName: "gallery"),
                  InstagramNav(imageName: "list"),
                  InstagramNav(imageName: "liked"),
                  InstagramNav(imageName: "saved")]
    
    var body: some View {
        XLPagerView(selection: 0, pagerSettings: PagerSettings(height: 500, tabItemSpacing: 0, tabItemHeight: 50)) {
            ForEach(0...3, id: \.self) { idx in
                PostsList().pagerTabItem {
                    titles[idx]
                }
            }
        }
        .frame(alignment: .center)
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
