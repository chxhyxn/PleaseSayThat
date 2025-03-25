//
//  StatusBarController.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var timer: Timer?
    private var timeLeft: Int = 0
    private var isTimerRunning = false
    
    init() {
        // 먼저 popover 초기화
        popover = NSPopover()
        popover.contentSize = NSSize(width: 240, height: 180)
        popover.behavior = .transient
        
        // 그 다음 statusBar 초기화
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(systemSymbolName: "message", accessibilityDescription: "Message")
            statusBarButton.action = #selector(togglePopover)
            statusBarButton.target = self
        }
        
        // 마지막으로 popover의 contentViewController 설정
        popover.contentViewController = NSHostingController(rootView: Color(.red))
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            if let statusBarButton = statusItem.button {
                popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .minY)
            }
        }
    }
}
