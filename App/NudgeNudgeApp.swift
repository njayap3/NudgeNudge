import SwiftUI
import SwiftData

@main
struct NudgeNudgeApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(dependencies)
        }
        .modelContainer(AppDependencies.modelContainer)
    }
}
