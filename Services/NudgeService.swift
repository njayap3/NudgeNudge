import Foundation
import SwiftData

final class NudgeService {
    func activate(_ nudge: Nudge, using notificationService: NotificationService) async throws {
        nudge.isActive = true
        try await notificationService.schedule(nudge)
    }

    func deactivate(_ nudge: Nudge, using notificationService: NotificationService) {
        nudge.isActive = false
        notificationService.cancel(nudge)
    }

    func delete(_ nudge: Nudge, context: ModelContext, using notificationService: NotificationService) {
        notificationService.cancel(nudge)
        context.delete(nudge)
    }
}
