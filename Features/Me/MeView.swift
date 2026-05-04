import SwiftUI

struct MeView: View {
    @AppStorage("userName") private var userName = ""
    @State private var nameInput = ""
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Your name") {
                    if isEditing {
                        HStack {
                            TextField("Your name", text: $nameInput)
                            Button("Save") {
                                userName = nameInput.trimmingCharacters(in: .whitespaces)
                                isEditing = false
                            }
                            .disabled(nameInput.trimmingCharacters(in: .whitespaces).isEmpty)
                            .tint(Color.nudgePink)
                        }
                    } else {
                        HStack {
                            Text(userName.isEmpty ? "Tap to set your name" : userName)
                                .foregroundStyle(userName.isEmpty ? .secondary : .primary)
                            Spacer()
                            Button("Edit") {
                                nameInput = userName
                                isEditing = true
                            }
                            .font(.callout)
                            .tint(Color.nudgePink)
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Spacer()
                        Image("NudgeLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)

                    LabeledContent("Version") {
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Me")
        }
        .onAppear {
            if userName.isEmpty { isEditing = true }
        }
    }
}

#Preview {
    MeView()
}
