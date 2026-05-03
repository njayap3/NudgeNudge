import SwiftUI

struct NudgeRowView: View {
    let nudge: Nudge

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(nudge.isActive ? Color.accentColor : .secondary)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(nudge.title)
                    .font(.headline)
                Text(nudge.schedule.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !nudge.isActive {
                Text("Paused")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.15))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
