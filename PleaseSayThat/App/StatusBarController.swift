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
    
    init() {
        // 먼저 popover 초기화
        popover = NSPopover()
        popover.contentSize = NSSize(width: 240, height: 180)
        popover.behavior = .applicationDefined
//        popover.delegate = self
        
        // 그 다음 statusBar 초기화
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusBarButton = statusItem.button {
            // 시작할 때는 popover가 닫혀있으므로 picket_off 이미지 사용
            statusBarButton.image = NSImage(named: "picket_off")
            statusBarButton.action = #selector(togglePopover)
            statusBarButton.target = self
        }
        
        // 마지막으로 popover의 contentViewController 설정
        popover.contentViewController = NSHostingController(rootView: PopOverView())
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }
    
    func showPopover() {
        if let statusBarButton = statusItem.button {
            // popover가 보여질 때 picket_on 이미지로 변경
            statusBarButton.image = NSImage(named: "picket_on")
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .minY)
            
            // 팝오버가 열렸을 때 focus를 가져오도록 설정
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    func closePopover() {
        // popover가 닫힐 때 picket_off 이미지로 변경
        statusItem.button?.image = NSImage(named: "picket_off")
        popover.performClose(nil)
    }
}

// NSPopoverDelegate를 추가하여 popover가 외부 클릭으로 닫힐 때도 이미지 변경
//extension StatusBarController: NSPopoverDelegate {
//    func popoverDidClose(_ notification: Notification) {
//        statusItem.button?.image = NSImage(named: "picket_off")
//    }
//}
