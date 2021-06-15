//
//  View+Extension.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 14/4/21.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content:View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

/*
 EXAMPLE
 -------
 
 struct ContentView: View {

 var body: some View {
     Text("Hello, world!")
         .padding()
         .if(.iOS13) { view in
             view.background(Color.red)
         }
 }
}
 **/
