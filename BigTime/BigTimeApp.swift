//
//  BigTimeApp.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//

import SwiftUI

@main
struct BigTimeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("aboutMenuLabel") {
                    AboutWindowController.shared.showAboutView()
                }
            }
        }
    }
}
