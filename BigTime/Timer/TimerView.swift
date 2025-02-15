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
        VStack(alignment: .leading, spacing: 50) {
            Text(timerViewModel.formattedTime)
                .font(.system(size: 48, weight: .light, design: .monospaced))
            
            LuminareSection("optionsLabel") {
                LuminareTextField("enterTaskLabel", text: $timerViewModel.currentTask)
                
                if timerViewModel.selectedSession != nil {
                    // Show editing controls when a session is selected
                    HStack(spacing: 2) {
                        Button(action: {
                            if let session = timerViewModel.selectedSession {
                                let updatedSession = TimerSession(
                                    id: session.id,
                                    startDate: session.startDate,
                                    duration: timerViewModel.elapsedSeconds,
                                    label: timerViewModel.currentTask
                                )
                                timerViewModel.updateSessionLabel(session, newLabel: timerViewModel.currentTask)
                                timerViewModel.continueFromSession(updatedSession)
                                timerViewModel.selectedSession = nil
                            }
                        }) {
                            Label("continueLabel", systemImage: "arrow.right")
                        }
                        .background(Color.accentColor.opacity(0.2))
                        
                        Button(action: {
                            if let session = timerViewModel.selectedSession {
                                timerViewModel.deleteSession(session)
                            }
                            timerViewModel.selectedSession = nil
                            timerViewModel.resetTimer()
                        }) {
                            Label("deleteLabel", systemImage: "trash")
                        }
                        .buttonStyle(LuminareDestructiveButtonStyle())
                    }
                } else {
                    // Show normal timer controls
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
                        .buttonStyle(LuminareDestructiveButtonStyle())
                    }
                }
            }
            .frame(height: 35)
            
            if timerViewModel.selectedSession != nil {
                LuminareSection {
                    HStack(spacing: 2) {
                        if let session = timerViewModel.selectedSession {
                            Button(action: {
                                timerViewModel.togglePin(for: session)
                            }) {
                                Label("pinLabel", systemImage: session.isPinned ? "pin.slash.fill" : "pin.fill")
                            }
                            .background(Color.accentColor.opacity(0.2))
                        }
                        
                        Button(action: {
                            timerViewModel.selectedSession = nil
                            timerViewModel.resetTimer()
                        }) {
                            Label("closeLabel", systemImage: "xmark")
                        }
                    }
                }
                .frame(height: 35)
            }
        }
        .buttonStyle(LuminareButtonStyle())
        .toolbar() {
            if timerViewModel.selectedSession != nil {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        timerViewModel.selectedSession = nil
                        timerViewModel.resetTimer()
                    }) {
                        Label("homeLabel", systemImage: "house")
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 350, maxWidth: 400, minHeight: 350, maxHeight: 400)
        .navigationTitle("appName")
    }
}
