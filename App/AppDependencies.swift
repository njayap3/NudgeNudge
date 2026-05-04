import SwiftUI
import SwiftData

@Observable
final class AppDependencies {
    let notificationService: NotificationService

    init(notificationService: NotificationService = .init()) {
        self.notificationService = notificationService
    }

    static let modelContainer: ModelContainer = {
        let schema = Schema([Person.self, NudgeRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
}
