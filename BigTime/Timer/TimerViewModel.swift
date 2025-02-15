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
    @Published var sessions: [TimerSession] = []
    @Published var selectedSession: TimerSession?
    @Published var currentTask: String = "" {
        didSet {
            if let session = selectedSession {
                updateSessionLabel(session, newLabel: currentTask)
            }
        }
    }
    private let floatingController = FloatingTimerController()

    private var timer: Timer?
    private var startDate: Date?
    
    init() {
        loadSessions()
    }
    
    var pinnedSessions: [TimerSession] {
        sessions.filter { $0.isPinned }
    }
    
    var unpinnedSessions: [TimerSession] {
        sessions.filter { !$0.isPinned }
    }
    
    var formattedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func togglePin(for session: TimerSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index].isPinned.toggle()
            saveSessions() // Save the updated sessions
        }
    }
    
    func toggleTimer() {
         isRunning.toggle()
         if isRunning {
             startTimer()
             startDate = Date()
             floatingController.showFloatingTimer(with: self)
         } else {
             stopTimer()
             saveSession()
             floatingController.hideFloatingTimer()
             // Reset after saving
             resetTimer()
             currentTask = ""
         }
    }
    
    func resetTimer() {
        stopTimer()
        elapsedSeconds = 0
        startDate = nil
        isRunning = false
        floatingController.hideFloatingTimer()
        currentTask = ""
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
        
        // Check if this is an existing session being saved again
        let existingSession = sessions.first(where: { $0.label == currentTask })
        let isPinned = existingSession?.isPinned ?? false  // Preserve pin state
        
        let session = TimerSession(
            id: UUID(),
            startDate: startDate,
            duration: elapsedSeconds,
            label: currentTask.isEmpty ? "Unlabeled Session" : currentTask,
            isPinned: isPinned  // Carry over the pin state
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
    
    func continueFromSession(_ session: TimerSession) {
        resetTimer()
        elapsedSeconds = session.duration
        currentTask = session.label
        deleteSession(session) // delete old timer instance
        startTimer()
        startDate = Date()
        isRunning = true
        
        floatingController.showFloatingTimer(with: self)
    }
    
    func updateCurrentTime(_ newSeconds: Int) {
        elapsedSeconds = max(0, newSeconds)
    }
}
