//
//  HistoryView.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//

import SwiftUI
import Luminare

struct HistoryView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("historyTitle")
                .font(.title2)
                .padding(.horizontal)
            List {
                ForEach(timerViewModel.sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.label)
                        
                        HStack {
                            Text(session.startDate, style: .date)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text(session.formattedDuration)
                                .font(.system(.subheadline, design: .monospaced))
                        }
                        .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        timerViewModel.selectedSession = session
                        timerViewModel.currentTask = session.label
                        timerViewModel.updateCurrentTime(session.duration)
                    }
                }
            }
            .disabled(timerViewModel.isRunning)
            .foregroundStyle(timerViewModel.isRunning ? .tertiary : .primary)
            .scrollContentBackground(.hidden)
        }
    }
}
