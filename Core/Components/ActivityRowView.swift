import SwiftUI

struct ActivityRowView: View {
    let record: NudgeRecord

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(record.direction == .sent
                          ? Color.nudgePink.opacity(0.12)
                          : Color.nudgeTeal.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: record.direction == .sent ? "arrow.up.right" : "arrow.down.left")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(record.direction == .sent ? Color.nudgePink : Color.nudgeTeal)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(record.displayLabel)
                    .font(.subheadline.weight(.medium))
                Text(record.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(record.timestamp.relativeDisplay)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }
}
