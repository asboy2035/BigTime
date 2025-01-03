//
//  TimerView.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//


import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(timerViewModel.formattedTime)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .padding(.bottom)
                .padding(.horizontal)
            
            TextField("Enter task", text: $timerViewModel.currentTask)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 0)
            
            HStack {
                Button(action: timerViewModel.toggleTimer) {
                    HStack(spacing: 4) {
                        Image(systemName: timerViewModel.isRunning ? "clock.badge.checkmark" : "play.fill")
                            .frame(width: 15, height: 25)
                        Text(timerViewModel.isRunning ? "Done" : "Start")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: timerViewModel.resetTimer) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .frame(width: 15, height: 25)
                        Text("Reset")
                            .font(.body)
                    }
                    .frame(alignment: .leading)
                }
            }
            .padding(.horizontal)
        }
        Spacer()
        .navigationTitle("Timer")
//        .background(
//            VisualEffectBlur()
//                .ignoresSafeArea()
//        )
    }
}
