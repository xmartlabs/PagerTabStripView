//
//  User.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var image: Image {
        Image("margeSimpson")
    }
}
