import SwiftUI
import SwiftData

struct SendNudgeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let person: Person

    @State private var selectedPreset: NudgePreset? = nil
    @State private var customMessage = ""

    private var messageToSend: String? {
        let trimmed = customMessage.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty { return trimmed }
        return selectedPreset?.full
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Person header
                VStack(spacing: 8) {
                    Circle()
                        .fill(person.avatarColor)
                        .frame(width: 60, height: 60)
                        .overlay {
                            Text(person.initial)
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                    Text(person.name)
                        .font(.title3.weight(.bold))
                    Text(person.tier.emoji + " " + person.tier.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 20)

                Divider()

                // Preset options
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(NudgePreset.all) { preset in
                            Button {
                                if selectedPreset?.id == preset.id {
                                    selectedPreset = nil
                                } else {
                                    selectedPreset = preset
                                    customMessage = ""
                                }
                            } label: {
                                HStack(spacing: 16) {
                                    Text(preset.emoji)
                                        .font(.title3)
                                        .frame(width: 32)
                                    Text(preset.text)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if selectedPreset?.id == preset.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.nudgePink)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(
                                    selectedPreset?.id == preset.id
                                        ? Color.nudgePink.opacity(0.07)
                                        : Color.clear
                                )
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            Divider().padding(.leading, 68)
                        }
                    }
                }

                Divider()

                // Custom input + send button
                HStack(spacing: 12) {
                    TextField("Add your own...", text: $customMessage)
                        .onChange(of: customMessage) { _, new in
                            if !new.isEmpty { selectedPreset = nil }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                    Button { send() } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 46, height: 46)
                            .background(
                                messageToSend != nil ? Color.nudgePink : Color(.systemGray4),
                                in: Circle()
                            )
                    }
                    .disabled(messageToSend == nil)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func send() {
        guard let message = messageToSend else { return }
        let record = NudgeRecord(personName: person.name, direction: .sent, message: message)
        record.person = person
        modelContext.insert(record)
        person.lastNudgedAt = .now
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, NudgeRecord.self, configurations: config)
    let person = Person(name: "Mom", tier: .daily)
    container.mainContext.insert(person)
    return SendNudgeView(person: person)
        .modelContainer(container)
}
