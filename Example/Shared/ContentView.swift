//
//  ContentView.swift
//  Shared
//
//  Copyright © 2020 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
#if iOS
import PagerTabStrip
#endif

struct NavBar: View {
    var body: some View {
        HStack(){
            Button("NavBar") {
                
            }
        }
    }
}

struct PagerData {
    internal static var pageItems = [Any]()
}

struct XLPagerTabView<Content> : View where Content : View {
    
    enum PagerType {
        case twitter
        case youtube
    }

    private var type: PagerType
    private var content: () -> Content
    
    public init(_ type: PagerType = .twitter,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
    }
    
    var body: some View {
        VStack {
            if type == .youtube {
                NavBar()
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color.red)
            }
            GeometryReader { gproxy in
                ScrollView(.horizontal) {
                    ScrollViewReader { sproxy in
                        LazyHStack {
                            let a = self.content()
                            a.frame(width: gproxy.size.width, alignment: .center)
                        }
                        .background(Color.blue)
                    }
                }
            }
        }
    }
}

protocol PagerView: View, Hashable {
    static var tabImage: Image? { get set }
    static var tabText: Image? { get set }
}

struct ContentView: View {
    var body: some View {
        XLPagerTabView(.youtube) {
            ForEach(1...5, id: \.self) { idx in
                Text("Pager")
                    .onAppear {
                        print("Page: \(idx)")
                    }
            }
            
        }
        .frame(alignment: .center)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 7.0, *)
extension View {
    public func pagerItem<V>(@ViewBuilder _ label: () -> V) -> some View where V : View {
        //PagerData.pageItems.append(label as! Any)
        return self
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
