//
//  TimerSession.swift
//  BigTime
//
//  Created by ash on 1/2/25.
//

import Foundation

struct TimerSession: Identifiable, Codable {
    let id: UUID
    let startDate: Date
    let duration: Int
    var label: String
    var isPinned: Bool = false
    
    var formattedDuration: String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
