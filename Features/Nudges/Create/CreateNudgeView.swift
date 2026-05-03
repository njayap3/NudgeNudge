import SwiftUI
import SwiftData

struct CreateNudgeView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = CreateNudgeViewModel()
    @State private var isSaving = false
    @State private var error: Error?

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $viewModel.title)
                    TextField("Message", text: $viewModel.message, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Schedule") {
                    Picker("Type", selection: $viewModel.scheduleType) {
                        ForEach(CreateNudgeViewModel.ScheduleType.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)

                    if viewModel.scheduleType == .weekly {
                        Picker("Day", selection: $viewModel.weekday) {
                            ForEach(1...7, id: \.self) { day in
                                Text(Calendar.current.weekdaySymbols[day - 1]).tag(day)
                            }
                        }
                    }

                    if viewModel.scheduleType != .interval {
                        DatePicker(
                            "Time",
                            selection: Binding(
                                get: {
                                    Calendar.current.date(
                                        bySettingHour: viewModel.hour,
                                        minute: viewModel.minute,
                                        second: 0,
                                        of: .now
                                    ) ?? .now
                                },
                                set: {
                                    viewModel.hour = Calendar.current.component(.hour, from: $0)
                                    viewModel.minute = Calendar.current.component(.minute, from: $0)
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                    } else {
                        Stepper("Every \(viewModel.intervalHours)h", value: $viewModel.intervalHours, in: 1...24)
                    }
                }
            }
            .navigationTitle("New Nudge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!viewModel.isValid || isSaving)
                }
            }
            .alert("Error", isPresented: Binding(get: { error != nil }, set: { if !$0 { error = nil } })) {
                Button("OK") { error = nil }
            } message: {
                Text(error?.localizedDescription ?? "")
            }
        }
    }

    private func save() {
        isSaving = true
        Task {
            do {
                try await viewModel.save(
                    context: modelContext,
                    nudgeService: dependencies.nudgeService,
                    notificationService: dependencies.notificationService
                )
                dismiss()
            } catch {
                self.error = error
            }
            isSaving = false
        }
    }
}

#Preview {
    CreateNudgeView()
        .environment(AppDependencies())
        .modelContainer(AppDependencies.modelContainer)
}
