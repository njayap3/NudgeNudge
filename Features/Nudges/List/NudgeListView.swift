import SwiftUI
import SwiftData

struct NudgeListView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.createdAt, order: .reverse) private var nudges: [Nudge]

    @State private var viewModel: NudgeListViewModel?

    private var filtered: [Nudge] {
        guard let vm = viewModel, !vm.searchText.isEmpty else { return nudges }
        return nudges.filter {
            $0.title.localizedCaseInsensitiveContains(vm.searchText) ||
            $0.message.localizedCaseInsensitiveContains(vm.searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered) { nudge in
                    NavigationLink(destination: NudgeDetailView(nudge: nudge)) {
                        NudgeRowView(nudge: nudge)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel?.delete(nudge, context: modelContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            Task { try? await viewModel?.toggleActive(nudge) }
                        } label: {
                            Label(nudge.isActive ? "Pause" : "Activate",
                                  systemImage: nudge.isActive ? "pause.fill" : "play.fill")
                        }
                        .tint(nudge.isActive ? .orange : .green)
                    }
                }
            }
            .navigationTitle("Nudges")
            .searchable(text: Binding(
                get: { viewModel?.searchText ?? "" },
                set: { viewModel?.searchText = $0 }
            ))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel?.showingCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel?.showingCreateSheet ?? false },
                set: { viewModel?.showingCreateSheet = $0 }
            )) {
                CreateNudgeView()
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = NudgeListViewModel(
                        nudgeService: dependencies.nudgeService,
                        notificationService: dependencies.notificationService
                    )
                }
            }
        }
    }
}

#Preview {
    NudgeListView()
        .environment(AppDependencies())
        .modelContainer(AppDependencies.modelContainer)
}
