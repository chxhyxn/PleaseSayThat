//
//  AppDelegate.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//


import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController()
    }
}
