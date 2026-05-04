import SwiftUI
import SwiftData

struct ActivityView: View {
    @Query(sort: \NudgeRecord.timestamp, order: .reverse) private var records: [NudgeRecord]

    private var grouped: [(label: String, items: [NudgeRecord])] {
        let order = ["Today", "Yesterday", "This week", "Earlier"]
        let groups = Dictionary(grouping: records) { $0.timestamp.nudgeGroupLabel }
        return order.compactMap { label in
            guard let items = groups[label], !items.isEmpty else { return nil }
            return (label: label, items: items)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    ContentUnavailableView(
                        "No activity yet",
                        systemImage: "bell.slash",
                        description: Text("Your nudge history will show up here.")
                    )
                } else {
                    List {
                        ForEach(grouped, id: \.label) { group in
                            Section(group.label) {
                                ForEach(group.items) { record in
                                    ActivityRowView(record: record)
                                        .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    ActivityView()
        .modelContainer(AppDependencies.modelContainer)
}
