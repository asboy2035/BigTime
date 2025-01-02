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
            TimerView()
                .environmentObject(timerViewModel)
                .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 300)
        } detail: {
            HistoryView()
                .environmentObject(timerViewModel)
                .background(
                    VisualEffectBlur()
                        .ignoresSafeArea()
                )
        }
        .accentColor(.indigo)
    }
}
