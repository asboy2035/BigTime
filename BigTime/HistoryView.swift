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
    @State private var editingSession: TimerSession?
    @State private var editedLabel: String = ""
    @State private var editedDuration: Int = 0
    
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
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(session.formattedDuration)
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingSession = session
                        editedLabel = session.label
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .sheet(item: $editingSession) { session in
                NavigationStack {
                    VStack(spacing: 20) {
                        Text("editSessionTitle")
                            .font(.system(.title2, design: .monospaced))
                        
                        LuminareSection {
                            LuminareTextField("sessionLabelField", text: $editedLabel)
                            
                            // Timer preview/editor
                            HStack(spacing: 2) {
                                // Hours
                                Stepper(
                                    value: Binding(
                                        get: { editedDuration / 3600 },
                                        set: { editedDuration = ($0 * 3600) + (editedDuration % 3600) }
                                    ),
                                    in: 0...23
                                ) {
                                    Text("\(editedDuration / 3600)h")
                                }
                                
                                // Minutes
                                Stepper(
                                    value: Binding(
                                        get: { (editedDuration % 3600) / 60 },
                                        set: { editedDuration = (editedDuration / 3600 * 3600) + ($0 * 60) + (editedDuration % 60) }
                                    ),
                                    in: 0...59
                                ) {
                                    Text("\((editedDuration % 3600) / 60)m")
                                }
                                
                                // Seconds
                                Stepper(
                                    value: Binding(
                                        get: { editedDuration % 60 },
                                        set: { editedDuration = (editedDuration / 60 * 60) + $0 }
                                    ),
                                    in: 0...59
                                ) {
                                    Text("\(editedDuration % 60)s")
                                }
                            }
                            .font(.system(.body, design: .monospaced))
                            
                            HStack(spacing: 2) {
                                Button("saveLabel") {
                                    if let session = editingSession {
                                        timerViewModel.updateSessionLabel(session, newLabel: editedLabel)
                                    }
                                    editingSession = nil
                                }
                                .background(Color.accentColor.opacity(0.2))
                                
                                Button("continueLabel") {
                                    if let session = editingSession {
                                        let updatedSession = TimerSession(
                                            id: session.id,
                                            startDate: session.startDate,
                                            duration: editedDuration,
                                            label: editedLabel
                                        )
                                        timerViewModel.updateSessionLabel(session, newLabel: editedLabel)
                                        timerViewModel.continueFromSession(updatedSession)
                                    }
                                    editingSession = nil
                                }
                                .background(Color.green.opacity(0.2))
                            }
                            
                            HStack(spacing: 2) {
                                Button("cancelLabel") {
                                    editingSession = nil
                                }

                                Button("deleteLabel") {
                                    if let session = editingSession {
                                        timerViewModel.deleteSession(session)
                                    }
                                    editingSession = nil
                                }
                                .buttonStyle(LuminareDestructiveButtonStyle())
                            }
                        }
                        .buttonStyle(LuminareButtonStyle())
                    }
                    .onAppear {
                        if let session = editingSession {
                            editedLabel = session.label
                            editedDuration = session.duration
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 350)
            }
        }
    }
}
