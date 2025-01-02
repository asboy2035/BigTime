//
//  TimerViewModel.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//


import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var elapsedSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentTask: String = ""
    @Published var sessions: [TimerSession] = []
    
    private var timer: Timer?
    private var startDate: Date?
    
    init() {
        loadSessions()
    }
    
    var formattedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            startTimer()
            startDate = Date()
        } else {
            stopTimer()
            saveSession()
        }
    }
    
    func resetTimer() {
        stopTimer()
        elapsedSeconds = 0
        startDate = nil
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func saveSession() {
        guard let startDate = startDate else { return }
        
        let session = TimerSession(
            id: UUID(),
            startDate: startDate,
            duration: elapsedSeconds,
            label: currentTask.isEmpty ? "Unlabeled Session" : currentTask
        )
        
        sessions.insert(session, at: 0)
        saveSessions()
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "TimerSessions")
        }
    }
    
    func deleteSession(_ session: TimerSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions.remove(at: index)
            saveSessions()  // Save the updated list of sessions after deletion
        }
    }
    
    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "TimerSessions"),
           let decoded = try? JSONDecoder().decode([TimerSession].self, from: data) {
            sessions = decoded
        }
    }
    
    func updateSessionLabel(_ session: TimerSession, newLabel: String) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = TimerSession(
                id: session.id,
                startDate: session.startDate,
                duration: session.duration,
                label: newLabel
            )
            saveSessions()
        }
    }
}
