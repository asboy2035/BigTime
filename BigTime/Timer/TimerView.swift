//
//  TimerView.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//


import SwiftUI
import Luminare

struct TimerView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(timerViewModel.formattedTime)
                .font(.system(size: 48, weight: .light, design: .monospaced))
            
            LuminareSection("optionsLabel") {
                LuminareTextField("enterTaskLabel", text: $timerViewModel.currentTask)
                
                HStack(spacing: 2) {
                    Button(action: timerViewModel.toggleTimer) {
                        Label(
                            timerViewModel.isRunning ? "doneLabel" : "startLabel",
                            systemImage: timerViewModel.isRunning ? "checkmark" : "play.fill"
                        )
                    }
                    
                    Button(action: timerViewModel.resetTimer) {
                        Label(
                            "resetLabel",
                            systemImage: "xmark"
                        )
                    }
                }
                .frame(height: 35)
                .buttonStyle(LuminareButtonStyle())
            }
        }
        .padding()
        .frame(minWidth: 350, maxWidth: 400, minHeight: 350, maxHeight: 400)
        .navigationTitle("appName")
    }
}
