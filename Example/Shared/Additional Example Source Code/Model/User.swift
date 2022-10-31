//
//  User.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation

struct User: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var imageURL: String
    var image: URLImageView {
        URLImageView(urlString: imageURL)
    }
}
