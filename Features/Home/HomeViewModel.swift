import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    var notificationAuthorizationGranted = false
    private let notificationService: NotificationService

    init(notificationService: NotificationService) {
        self.notificationService = notificationService
    }

    func requestNotificationPermission() async {
        notificationAuthorizationGranted = (try? await notificationService.requestAuthorization()) ?? false
    }
}
