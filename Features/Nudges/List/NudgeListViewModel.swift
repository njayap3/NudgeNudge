import SwiftUI
import SwiftData

@Observable
final class NudgeListViewModel {
    var searchText = ""
    var showingCreateSheet = false

    private let nudgeService: NudgeService
    private let notificationService: NotificationService

    init(nudgeService: NudgeService, notificationService: NotificationService) {
        self.nudgeService = nudgeService
        self.notificationService = notificationService
    }

    func toggleActive(_ nudge: Nudge) async throws {
        if nudge.isActive {
            nudgeService.deactivate(nudge, using: notificationService)
        } else {
            try await nudgeService.activate(nudge, using: notificationService)
        }
    }

    func delete(_ nudge: Nudge, context: ModelContext) {
        nudgeService.delete(nudge, context: context, using: notificationService)
    }
}
