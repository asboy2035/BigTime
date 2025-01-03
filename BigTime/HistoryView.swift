//
//  HistoryView.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State private var editingSession: TimerSession?
    @State private var editedLabel: String = ""
    @State private var editedDuration: Int = 0
    
    var filteredSessions: [TimerSession] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return timerViewModel.sessions.filter { session in
            session.startDate >= oneWeekAgo
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("History")
                .font(.system(.title, design: .monospaced))
                .padding()
            List {
                ForEach(filteredSessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.label)
                            .font(.headline)
                        
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
            .scrollContentBackground(.hidden) // Hides the default background
            .background(Color.clear)         // Sets the background to transparent
            .navigationTitle("BigTime")
            .sheet(item: $editingSession) { session in
                NavigationView {
                    VStack(spacing: 20) {
                        Text("Edit Session")
                            .font(.system(.title2, design: .monospaced))
                        
                        Form {
                            Section {
                                TextField("Session Label", text: $editedLabel)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                // Timer preview/editor
                                HStack {
                                    Text("Duration:")
                                    Spacer()
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
                                                .font(.system(.body, design: .monospaced))
                                                .frame(width: 40)
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
                                                .font(.system(.body, design: .monospaced))
                                                .frame(width: 40)
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
                                                .font(.system(.body, design: .monospaced))
                                                .frame(width: 40)
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 12) {
                            Button("Cancel") {
                                editingSession = nil
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Continue") {
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
                            .buttonStyle(.borderedProminent)
                            
                            Button("Save") {
                                if let session = editingSession {
                                    timerViewModel.updateSessionLabel(session, newLabel: editedLabel)
                                }
                                editingSession = nil
                            }
                            .buttonStyle(.bordered)
                            .background(Color.accentColor) // Use the accent color as the background
                            .cornerRadius(5)

                            Button("Delete") {
                                if let session = editingSession {
                                    timerViewModel.deleteSession(session)
                                }
                                editingSession = nil
                            }
                            .background(Color.red.opacity(0.5)) // Light red background
                            .cornerRadius(5)
                        }
                    }
                    .onAppear {
                        if let session = editingSession {
                            editedLabel = session.label
                            editedDuration = session.duration
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 200, alignment: .center)
                }
                .frame(width: 300, height: 200, alignment: .center)
            }
        }
    }
}
