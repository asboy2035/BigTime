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
            // Pinned Sessions Section
            if !timerViewModel.pinnedSessions.isEmpty {
                LuminareSection("pinnedSessionsTitle") {
                    ForEach(timerViewModel.pinnedSessions) { session in
                        Button(action: {
                            timerViewModel.selectedSession = session
                            timerViewModel.currentTask = session.label
                            timerViewModel.updateCurrentTime(session.duration)
                            
                            timerViewModel.togglePin(for: session) // reinstate pin status
                        }) {
                            HStack {
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
                                .padding(12)
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .padding()
            }
            
            // Unpinned Sessions Section
            LuminareSection("historyTitle") {
                if timerViewModel.unpinnedSessions.isEmpty {
                    Text("startATimerCTA")
                        .foregroundStyle(.secondary)
                }
                
                ForEach(timerViewModel.unpinnedSessions) { session in
                    Button(action: {
                        timerViewModel.selectedSession = session
                        timerViewModel.currentTask = session.label
                        timerViewModel.updateCurrentTime(session.duration)
                    }) {
                        HStack {
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
                            .padding(12)
                        }
                    }
                    .frame(height: 50)
                }
            }
            .padding()
            .disabled(timerViewModel.isRunning)
            .foregroundStyle(timerViewModel.isRunning ? .tertiary : .primary)
            Spacer()
        }
        .buttonStyle(LuminareButtonStyle())
    }
}
