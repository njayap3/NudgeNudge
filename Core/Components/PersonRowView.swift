import SwiftUI

struct PersonRowView: View {
    let person: Person

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(person.avatarColor)
                .frame(width: 46, height: 46)
                .overlay {
                    Text(person.initial)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(person.name)
                    .font(.headline)
                HStack(spacing: 4) {
                    Text(person.tier.emoji).font(.caption)
                    Text(person.tier.label).font(.caption).foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if let last = person.lastNudgedAt {
                    Text(last.relativeDisplay)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Circle()
                        .fill(urgencyColor(last: last))
                        .frame(width: 8, height: 8)
                } else {
                    Text("never")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Circle()
                        .fill(Color.red.opacity(0.7))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    private func urgencyColor(last: Date) -> Color {
        let days = Calendar.current.dateComponents([.day], from: last, to: .now).day ?? 0
        let threshold = person.tier == .daily ? 2 : 7
        if days >= threshold * 2 { return .red }
        if days >= threshold { return .orange }
        return Color.nudgePink.opacity(0.6)
    }
}
