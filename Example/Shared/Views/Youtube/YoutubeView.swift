//
//  YoutubeView.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 7/7/21.
//
import SwiftUI
import PagerTabStrip

struct YoutubeView: View {
    
    let titles = [YoutubeNavBarItem(title: "Home", imageName: "home"),
                  YoutubeNavBarItem(title: "Trending", imageName: "trending"),
                  YoutubeNavBarItem(title: "Account", imageName: "account")]
    
    @State var isLoading = false
    
    var body: some View {
        GeometryReader { gproxy in
            XLPagerView(selection: 0, pagerSettings: PagerSettings(tabItemSpacing: 0, tabItemHeight: 70)) {
//                if isLoading {
//                    ProgressView().frame(width: gproxy.size.width, height: 300, alignment: .center).pagerTabItem {
//                        titles[0]
//                    }
//                } else {
                    PostsList(isLoading: $isLoading).pagerTabItem {
                        titles[0]
                    }.onPageAppear {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
                //}
                
//                if isLoading {
//                    ProgressView().frame(width: gproxy.size.width, height: 300, alignment: .center).pagerTabItem {
//                        titles[1]
//                    }
//                } else {
                    PostsList(isLoading: $isLoading).pagerTabItem {
                        titles[1]
                    }.onPageAppear {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
                
                PostsList(isLoading: $isLoading).pagerTabItem {
                    titles[2]
                }.onPageAppear {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                //}
            }
            .frame(alignment: .center)
        }
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeView()
    }
}
