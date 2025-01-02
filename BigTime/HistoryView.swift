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
    
    var filteredSessions: [TimerSession] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return timerViewModel.sessions.filter { session in
            session.startDate >= oneWeekAgo
        }
    }
    
    var body: some View {
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
                        }
                    }
                    
                    HStack {
                        Button("Cancel") {
                            editingSession = nil
                        }
                        Button("Save") {
                            if let session = editingSession {
                                timerViewModel.updateSessionLabel(session, newLabel: editedLabel)
                            }
                            editingSession = nil
                        }
                        .font(.system(size: 12, weight: .medium))
                        .background(Color.accentColor) // Use the accent color as the background
                        .cornerRadius(5)
                        
                        Button("Delete") {
                            if let session = editingSession {
                                timerViewModel.deleteSession(session)
                            }
                            editingSession = nil
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red) // Red color for the delete button
                        .background(Color.red.opacity(0.5)) // Light red background
                        .cornerRadius(5)
                    }
                }
                .padding()
                .padding(.vertical, 50)
            }
            .frame(width: 300, height: 200, alignment: .center)
        }
    }
}
