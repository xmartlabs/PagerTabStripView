//
//  ExampleApp.swift
//  Shared
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

@main
struct ExampleApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
