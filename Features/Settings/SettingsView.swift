import SwiftUI

struct SettingsView: View {
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("badgeCount") private var badgeCount = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    Toggle("Haptic Feedback", isOn: $hapticFeedback)
                    Toggle("Badge Count", isOn: $badgeCount)
                }

                Section("About") {
                    LabeledContent("Version", value: appVersion)
                    LabeledContent("Build", value: buildNumber)
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }
}

#Preview {
    SettingsView()
}
