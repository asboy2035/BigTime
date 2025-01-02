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
        .navigationTitle("History")
        .sheet(item: $editingSession) { session in
            NavigationView {
                Form {
                    TextField("Session Label", text: $editedLabel)
                }
                .navigationTitle("Edit Session")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        editingSession = nil
                    },
                    trailing: Button("Save") {
                        timerViewModel.updateSessionLabel(session, newLabel: editedLabel)
                        editingSession = nil
                    }
                )
            }
        }
    }
}
