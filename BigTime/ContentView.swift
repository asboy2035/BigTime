//
//  ContentView.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    
    var body: some View {
        NavigationSplitView {
            HistoryView()
                .environmentObject(timerViewModel)
                .navigationSplitViewColumnWidth(min: 200, ideal: 350, max: 450)
        } detail: {
            TimerView()
                .environmentObject(timerViewModel)
        }
        .frame(minWidth: 700, minHeight: 400)
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow).ignoresSafeArea())
    }
}
