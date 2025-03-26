//
//  AppDelegate.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//


import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
        statusBar = StatusBarController()
        LaunchManager.shared.appState = .launched
    }
}
