import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Query(filter: #Predicate<Nudge> { $0.isActive }, sort: \.createdAt, order: .reverse)
    private var activeNudges: [Nudge]

    @State private var viewModel: HomeViewModel?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    summarySection
                    activeNudgesSection
                }
                .padding()
            }
            .navigationTitle("NudgeNudge")
            .task {
                let vm = HomeViewModel(notificationService: dependencies.notificationService)
                viewModel = vm
                await vm.requestNotificationPermission()
            }
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Active Nudges")
                .font(.headline)
            Text("\(activeNudges.count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var activeNudgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .font(.headline)
            if activeNudges.isEmpty {
                Text("No active nudges yet. Create one!")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(activeNudges.prefix(5)) { nudge in
                    NudgeRowView(nudge: nudge)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AppDependencies())
        .modelContainer(AppDependencies.modelContainer)
}
