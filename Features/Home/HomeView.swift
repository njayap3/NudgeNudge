import SwiftUI
import SwiftData

struct HomeView: View {
    @AppStorage("userName") private var userName = ""
    @Query(sort: \Person.addedAt) private var people: [Person]

    @State private var selectedTier: PersonTier? = nil
    @State private var nudgeTarget: Person? = nil
    @State private var showingAddPerson = false

    private var filteredPeople: [Person] {
        guard let tier = selectedTier else { return people }
        return people.filter { $0.tier == tier }
    }

    private var greetingLine: String {
        let h = Calendar.current.component(.hour, from: .now)
        if h < 12 { return "Good morning," }
        if h < 17 { return "Good afternoon," }
        return "Good evening,"
    }

    private var mostOverdue: Person? {
        people.min { ($0.lastNudgedAt ?? .distantPast) < ($1.lastNudgedAt ?? .distantPast) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Greeting
                    VStack(alignment: .leading, spacing: 2) {
                        Text(greetingLine)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text((userName.isEmpty ? "there" : userName) + " 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 4)

                    if people.isEmpty {
                        emptyState
                    } else {
                        // People list
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your People")
                                .font(.title3)
                                .fontWeight(.semibold)

                            ForEach(filteredPeople) { person in
                                Button { nudgeTarget = person } label: {
                                    PersonRowView(person: person)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                .buttonStyle(.plain)
                                .background(.background, in: RoundedRectangle(cornerRadius: 14))
                                .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                            }

                            // Tier filter pills
                            HStack(spacing: 8) {
                                FilterPill(label: "❤️ Daily", isSelected: selectedTier == .daily) {
                                    selectedTier = selectedTier == .daily ? nil : .daily
                                }
                                FilterPill(label: "🙂 Occasional", isSelected: selectedTier == .occasional) {
                                    selectedTier = selectedTier == .occasional ? nil : .occasional
                                }
                            }
                            .padding(.top, 2)
                        }

                        // Send nudge CTA
                        Button {
                            nudgeTarget = mostOverdue
                        } label: {
                            Label("Send a nudge", systemImage: "paperplane.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.nudgePink, in: RoundedRectangle(cornerRadius: 16))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("NudgeLogoCompact")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddPerson = true } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    .tint(Color.nudgePink)
                }
            }
        }
        .sheet(isPresented: $showingAddPerson) { AddPersonView() }
        .sheet(item: $nudgeTarget) { SendNudgeView(person: $0) }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("👥").font(.system(size: 64))
            Text("Add your people")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Keep up with the ones who matter.\nNo social feed, no likes — just a tap.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showingAddPerson = true
            } label: {
                Text("Add your first person")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.nudgePink, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
            }
        }
        .padding(.top, 40)
    }
}

struct FilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.nudgePink : Color.secondary.opacity(0.12), in: Capsule())
                .foregroundStyle(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .modelContainer(AppDependencies.modelContainer)
}
