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
    
    @State private var pageWidth : CGFloat = 0
    @State private var contentWidth : CGFloat = 0
    @State private var itemCount : Int = 0
    @State private var dragOffset : CGFloat = 0
    
    
    public init(_ type: PagerType = .twitter,
                selection: Int = 0,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
        self._currentPage = State(initialValue: selection)
    }
    
    func offsetForPageIndex(_ index: Int) -> CGFloat {
        return (CGFloat(index) * pageWidth) * -1.0
    }
    
    func indexPageForOffset(_ offset : CGFloat) -> Int {
        guard self.itemCount > 0 else {
            return 0
        }
        let floatIndex = (offset * -1) / pageWidth
        var computedIndex = Int(round(floatIndex))
        computedIndex = max(computedIndex, 0)
        return min(computedIndex, self.itemCount - 1)
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
                        ZStack(alignment: .leading){
                            LazyHStack(spacing: 0) {
                                self.content().frame(width: gproxy.size.width, alignment: .center)
                                    .background(Color.blue)
                            }
                            .offset(x: self.currentOffset, y: 0)
                            .simultaneousGesture( DragGesture(minimumDistance: 1, coordinateSpace: .local)
                                .onChanged { value in
                                    let previousTranslation = self.dragOffset
                                    self.dragOffset = value.translation.width
                                    self.currentOffset += self.dragOffset - previousTranslation
                                }
                                .onEnded { value in
                                    if self.dragOffset < 0 {
                                        self.currentPage =  min(self.currentPage + 1, self.itemCount - 1)
                                    } else if self.dragOffset > 0 {
                                        self.currentPage = max(self.currentPage - 1, 0)
                                    }
                                    self.currentOffset = self.offsetForPageIndex(currentPage)
                                    
                                    self.dragOffset = 0
                                }
                            )
                            GeometryReader { pproxy in
                                Color.clear.frame(width: 10, height: 10, alignment: .leading)
                                    .onAppear {
                                        self.currentOffset = pproxy.frame(in: .global).minX
                                        self.contentWidth = pproxy.frame(in: .global).width
                                    }
                            }
                        }
                    }
                    .onChange(of: self.currentPage) { index in
                        withAnimation {
                            sproxy.scrollTo(currentPage)
                            self.currentOffset = self.offsetForPageIndex(currentPage)
                        }
                    }
                }
                .onAppear {
                    self.pageWidth = gproxy.size.width
                    self.itemCount = Int(round(self.contentWidth / self.pageWidth))
                }
            }
            HStack {
                Text("Offset: \(self.currentOffset) Page: \(self.currentPage)")
            }
        }
    }
}
