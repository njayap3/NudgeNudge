import SwiftUI
import SwiftData

/// Central dependency container injected via SwiftUI environment.
@Observable
final class AppDependencies {
    let notificationService: NotificationService
    let nudgeService: NudgeService

    init(
        notificationService: NotificationService = .init(),
        nudgeService: NudgeService = .init()
    ) {
        self.notificationService = notificationService
        self.nudgeService = nudgeService
    }

    static let modelContainer: ModelContainer = {
        let schema = Schema([Nudge.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
}
