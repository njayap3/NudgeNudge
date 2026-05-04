import SwiftUI
import SwiftData

struct AddPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var tier: PersonTier = .occasional

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("e.g. Mom, Alex…", text: $name)
                }

                Section("Circle") {
                    ForEach(PersonTier.allCases, id: \.self) { t in
                        Button { tier = t } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(t.emoji + " " + t.label)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(t == .daily
                                         ? "Family & inner circle — check in often"
                                         : "Friends — catch up every now and then")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if tier == t {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.nudgePink)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addPerson() }
                        .disabled(!isValid)
                        .tint(Color.nudgePink)
                }
            }
        }
    }

    private func addPerson() {
        let person = Person(name: name.trimmingCharacters(in: .whitespaces), tier: tier)
        modelContext.insert(person)
        dismiss()
    }
}

#Preview {
    AddPersonView()
        .modelContainer(AppDependencies.modelContainer)
}
