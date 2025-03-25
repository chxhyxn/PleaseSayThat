//
//  PleaseSayThatApp.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

@main
struct PleaseSayThatApp: App {
    // Initialize UserManager when app launches
    @State private var userManager = UserManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Ensure UserManager is initialized when app appears
                    _ = userManager
                }
        }
    }
}
