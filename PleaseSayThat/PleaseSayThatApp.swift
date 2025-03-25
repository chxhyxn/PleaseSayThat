//
//  PleaseSayThatApp.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

@main
struct PleaseSayThatApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Initialize UserManager when app launches
    @State private var userManager = UserManager.shared
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
