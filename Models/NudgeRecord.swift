import Foundation
import SwiftData

@Model
final class NudgeRecord {
    var personName: String
    var direction: NudgeDirection
    var message: String
    var timestamp: Date
    var person: Person?

    init(personName: String, direction: NudgeDirection, message: String, timestamp: Date = .now) {
        self.personName = personName
        self.direction = direction
        self.message = message
        self.timestamp = timestamp
    }

    var displayLabel: String {
        switch direction {
        case .sent: return "You → \(personName)"
        case .received: return "\(personName) → You"
        }
    }
}

enum NudgeDirection: String, Codable {
    case sent
    case received
}
