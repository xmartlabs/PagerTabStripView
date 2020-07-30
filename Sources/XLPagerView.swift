//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//

import SwiftUI

struct NavBar: View {
    
    @State private var nextPage = 0
    @Binding private var indexSelected: Int
    
    public init(selection: Binding<Int>) {
        self._indexSelected = selection
    }
    
    var body: some View {
        HStack(){
            Button("Go To \(self.nextPage)") {
                self.indexSelected = nextPage
            }
            .onChange(of: self.indexSelected) { value in
                let newPage = Int.random(in: 1..<5)
                self.nextPage = newPage != self.nextPage ? newPage : newPage + 1
            }
        }
    }
}

public enum PagerType {
    case twitter
    case youtube
}

@available(iOS 14.0, *)
public struct XLPagerView<Content> : View where Content : View {

    private var type: PagerType
    private var content: () -> Content
    
    @State private var currentPage: Int
    @State private var currentOffset: CGFloat = 0
    
    public init(_ type: PagerType = .twitter,
                selection: Int = 1,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
        self._currentPage = State(initialValue: selection)
    }
    
    public var body: some View {
        VStack {
            if type == .youtube {
                NavBar(selection: self.$currentPage)
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color.red)
            }
            GeometryReader { gproxy in
                ScrollViewReader { sproxy in
                    ScrollView(.horizontal) {
                        GeometryReader { pproxy in
                            //self.currentOffset = pproxy.frame(in: .global).minX
                            LazyHStack {
                                let a = self.content()
                                a.frame(width: gproxy.size.width, alignment: .center)
                            }
                            .background(Color.blue)
                        }
                    }
                    .onChange(of: self.currentPage) { index in
                        withAnimation {
                            sproxy.scrollTo(currentPage)
                        }
                    }
                }
            }
            Text("\(self.currentOffset)")
        }
    }
}
