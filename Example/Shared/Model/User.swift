//
//  User.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var image: URLImageView {
        URLImageView(urlString: imageURL)
    }
}
