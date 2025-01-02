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
        VStack {
            Text(timerViewModel.formattedTime)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .padding()
            
            TextField("Enter task", text: $timerViewModel.currentTask)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: timerViewModel.toggleTimer) {
                    Text(timerViewModel.isRunning ? "Pause" : "Start")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: timerViewModel.resetTimer) {
                    Text("Reset")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            Spacer()
            
            NavigationLink(destination: HistoryView()) {
                Text("View History")
                    .font(.title2)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            VisualEffectBlur()
                .ignoresSafeArea()
        )
    }
}
