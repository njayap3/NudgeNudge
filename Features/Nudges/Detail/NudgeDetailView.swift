import SwiftUI

struct NudgeDetailView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.modelContext) private var modelContext
    let nudge: Nudge

    var body: some View {
        Form {
            Section("Info") {
                LabeledContent("Title", value: nudge.title)
                LabeledContent("Message", value: nudge.message)
                LabeledContent("Schedule", value: nudge.schedule.displayName)
            }

            Section("Status") {
                LabeledContent("Active") {
                    Image(systemName: nudge.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(nudge.isActive ? .green : .red)
                }
                if let last = nudge.lastTriggeredAt {
                    LabeledContent("Last triggered", value: last.formatted(.relative(presentation: .named)))
                }
            }
        }
        .navigationTitle(nudge.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
