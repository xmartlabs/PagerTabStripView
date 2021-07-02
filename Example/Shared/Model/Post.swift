//
//  Post.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import Foundation
import SwiftUI
import CoreLocation

struct Post: Hashable, Codable, Identifiable {
    var id: Int
    var text: String
    var created_at: String
    var user: User
}
