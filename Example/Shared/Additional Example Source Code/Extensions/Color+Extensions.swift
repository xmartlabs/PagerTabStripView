//
//  Color+Extensions.swift
//  Example
//
//  Created by Martin Barreto on 25/1/23.
//

import SwiftUI

extension Color {
    
    var components: (r: Double, g: Double, b: Double, o: Double)? {
        let uiColor: UIColor
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        if self.description.contains("NamedColor") {
            let lowerBound = self.description.range(of: "name: \"")!.upperBound
            let upperBound = self.description.range(of: "\", bundle")!.lowerBound
            let assetsName = String(self.description[lowerBound..<upperBound])

            uiColor = UIColor(named: assetsName)!
        } else {
            uiColor = UIColor(self)
        }

        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &o) else { return nil }
        return (Double(r), Double(g), Double(b), Double(o))
    }

    func interpolateTo(color: Color, fraction: Double) -> Color {
        let s = self.components!
        let t = color.components!
        
        let r: Double = s.r + (t.r - s.r) * fraction
        let g: Double = s.g + (t.g - s.g) * fraction
        let b: Double = s.b + (t.b - s.b) * fraction
        let o: Double = s.o + (t.o - s.o) * fraction
        
        return Color(red: r, green: g, blue: b, opacity: o)
    }
}
