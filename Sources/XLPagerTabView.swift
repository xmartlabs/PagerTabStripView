//
//  XLPagerTabView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//

import SwiftUI

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

public enum PagerType {
    case twitter
    case youtube
}

@available(iOS 14.0, *)
public struct XLPagerTabView<Content> : View where Content : View {

    private var type: PagerType
    private var content: () -> Content
    
    public init(_ type: PagerType = .twitter,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
    }
    
    public var body: some View {
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

@available(iOS 14.0, *)
struct XLPagerTabView_Previews: PreviewProvider {

    static var previews: some View {
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
