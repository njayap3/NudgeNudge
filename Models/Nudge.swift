import Foundation
import SwiftData

@Model
final class Nudge {
    var id: UUID
    var title: String
    var message: String
    var schedule: NudgeSchedule
    var isActive: Bool
    var createdAt: Date
    var lastTriggeredAt: Date?

    init(
        id: UUID = .init(),
        title: String,
        message: String,
        schedule: NudgeSchedule,
        isActive: Bool = true,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.schedule = schedule
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

enum NudgeSchedule: Codable {
    case daily(hour: Int, minute: Int)
    case weekly(weekday: Int, hour: Int, minute: Int)
    case interval(seconds: TimeInterval)

    var displayName: String {
        switch self {
        case let .daily(hour, minute):
            return "Daily at \(String(format: "%02d:%02d", hour, minute))"
        case let .weekly(weekday, hour, minute):
            let day = Calendar.current.weekdaySymbols[weekday - 1]
            return "\(day) at \(String(format: "%02d:%02d", hour, minute))"
        case let .interval(seconds):
            return "Every \(Int(seconds / 3600))h"
        }
    }
}
