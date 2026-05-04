import Foundation

struct NudgePreset: Identifiable {
    let id = UUID()
    let emoji: String
    let text: String

    var full: String { "\(emoji) \(text)" }

    static let all: [NudgePreset] = [
        .init(emoji: "👀", text: "u alive?"),
        .init(emoji: "🫡", text: "checking in"),
        .init(emoji: "🍵", text: "spill?"),
        .init(emoji: "🧠", text: "you good?"),
        .init(emoji: "🚨", text: "ping"),
        .init(emoji: "🌮", text: "you exist?"),
        .init(emoji: "🫶", text: "hi"),
        .init(emoji: "💤", text: "ghost?"),
    ]
}
