//
//  PagerTabViewDelegate.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 26/7/21.
//

import SwiftUI

public enum PagerTabViewState {
    case selected
    case highlighted
    case normal
}

public protocol PagerTabViewDelegate {
    func setState(state: PagerTabViewState)
}
