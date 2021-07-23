//
//  ExampleApp.swift
//  Shared
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

@main
struct ExampleApp: App {
    @StateObject private var factory = Factory()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(factory)
        }
    }
}
