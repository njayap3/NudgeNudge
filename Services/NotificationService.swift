import UserNotifications
import Foundation

final class NotificationService {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func schedule(_ nudge: Nudge) async throws {
        let content = UNMutableNotificationContent()
        content.title = nudge.title
        content.body = nudge.message
        content.sound = .default

        let trigger = nudge.schedule.notificationTrigger()
        let request = UNNotificationRequest(
            identifier: nudge.id.uuidString,
            content: content,
            trigger: trigger
        )
        try await center.add(request)
    }

    func cancel(_ nudge: Nudge) {
        center.removePendingNotificationRequests(withIdentifiers: [nudge.id.uuidString])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}

private extension NudgeSchedule {
    func notificationTrigger() -> UNNotificationTrigger {
        switch self {
        case let .daily(hour, minute):
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case let .weekly(weekday, hour, minute):
            var components = DateComponents()
            components.weekday = weekday
            components.hour = hour
            components.minute = minute
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case let .interval(seconds):
            return UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)
        }
    }
}
