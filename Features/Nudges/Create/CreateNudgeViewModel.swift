import SwiftUI
import SwiftData

@Observable
final class CreateNudgeViewModel {
    var title = ""
    var message = ""
    var scheduleType: ScheduleType = .daily
    var hour = 9
    var minute = 0
    var weekday = 2
    var intervalHours = 1

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !message.trimmingCharacters(in: .whitespaces).isEmpty
    }

    enum ScheduleType: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case interval = "Interval"
    }

    private var schedule: NudgeSchedule {
        switch scheduleType {
        case .daily: return .daily(hour: hour, minute: minute)
        case .weekly: return .weekly(weekday: weekday, hour: hour, minute: minute)
        case .interval: return .interval(seconds: TimeInterval(intervalHours * 3600))
        }
    }

    func save(context: ModelContext, nudgeService: NudgeService, notificationService: NotificationService) async throws {
        let nudge = Nudge(title: title, message: message, schedule: schedule)
        context.insert(nudge)
        try await nudgeService.activate(nudge, using: notificationService)
    }
}
