import UserNotifications
import Foundation

final class NotificationService {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}
