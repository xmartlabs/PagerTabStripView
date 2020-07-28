//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//

import SwiftUI

struct NavBar<SelectionValue>: View where SelectionValue : Hashable {
    
    @State var nextPage: Int = 0
    @Binding var selected: SelectionValue
    
    public init(selection: Binding<SelectionValue>) {
        self._selected = selection
    }
    
    var body: some View {
        HStack(){
            Button("Go To \(self.nextPage)") {
                self.selected = nextPage as! SelectionValue
            }
            .onChange(of: self.selected) { value in
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
public struct XLPagerView<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {

    private var type: PagerType
    private var content: () -> Content
    
    @Binding var selected: SelectionValue
    
    public init(_ type: PagerType = .twitter,
                selection: Binding<SelectionValue>,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
        self._selected = selection
    }
    
    public var body: some View {
        VStack {
            if type == .youtube {
                NavBar(selection: self.$selected)
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color.red)
            }
            GeometryReader { gproxy in
                ScrollViewReader { sproxy in
                    ScrollView(.horizontal) {
                        LazyHStack {
                            let a = self.content()
                            a.frame(width: gproxy.size.width, alignment: .center)
                        }
                        .background(Color.blue)
                    }
                    .onChange(of: self.selected) { index in
                        withAnimation {
                            sproxy.scrollTo(selected)
                        }
                    }
                }
            }
        }
    }
}
