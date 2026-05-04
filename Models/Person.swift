import Foundation
import SwiftData
import SwiftUI

@Model
final class Person {
    var name: String
    var tier: PersonTier
    var addedAt: Date
    var lastNudgedAt: Date?

    @Relationship(deleteRule: .cascade)
    var nudgeHistory: [NudgeRecord] = []

    init(name: String, tier: PersonTier = .occasional, addedAt: Date = .now) {
        self.name = name
        self.tier = tier
        self.addedAt = addedAt
    }

    var initial: String { String(name.prefix(1)).uppercased() }

    var avatarColor: Color {
        let palette: [Color] = [
            Color(red: 1.0, green: 0.42, blue: 0.42),
            Color(red: 0.31, green: 0.80, blue: 0.77),
            Color(red: 1.0, green: 0.65, blue: 0.31),
            Color(red: 0.55, green: 0.42, blue: 0.88),
            Color(red: 0.27, green: 0.63, blue: 0.89),
            Color(red: 0.96, green: 0.49, blue: 0.66),
            Color(red: 0.42, green: 0.75, blue: 0.45),
            Color(red: 0.94, green: 0.74, blue: 0.20),
        ]
        return palette[abs(name.hash) % palette.count]
    }
}

enum PersonTier: String, Codable, CaseIterable {
    case daily
    case occasional

    var label: String {
        switch self {
        case .daily: return "Daily"
        case .occasional: return "Occasional"
        }
    }

    var emoji: String {
        switch self {
        case .daily: return "❤️"
        case .occasional: return "🙂"
        }
    }
}
