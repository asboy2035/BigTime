//
//  FloatingTimerWindow.swift
//  BigTime
//
//  Created by ash on 2/15/25.
//


import SwiftUI

class FloatingTimerWindow: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 75),
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.level = .floating
        self.isFloatingPanel = true
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.backgroundColor = .clear
        
        // Center at the bottom of the screen
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowSize = self.frame.size
            let centerX = screenRect.origin.x + (screenRect.width - windowSize.width) / 2
            let bottomY = screenRect.origin.y + 20 // 20 pixels from bottom
            self.setFrameOrigin(NSPoint(x: centerX, y: bottomY))
        }
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
