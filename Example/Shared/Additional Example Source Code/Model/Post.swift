//
//  Post.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Foundation

struct Post: Hashable, Codable, Identifiable {
    var id: Int
    var text: String
    var created_at: String
    var user: User
}
