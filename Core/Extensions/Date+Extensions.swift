import Foundation

extension Date {
    var isToday: Bool { Calendar.current.isDateInToday(self) }
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    var relativeDisplay: String {
        let cal = Calendar.current
        let comps = cal.dateComponents([.minute, .hour, .day], from: self, to: .now)
        let mins = comps.minute ?? 0
        let hours = comps.hour ?? 0
        let days = comps.day ?? 0

        if days == 0 && hours == 0 {
            return mins < 2 ? "just now" : "\(mins)m ago"
        } else if days == 0 {
            return hours == 1 ? "1h ago" : "\(hours)h ago"
        } else if days == 1 {
            return "yesterday"
        } else if days < 7 {
            return "\(days) days ago"
        } else if days < 14 {
            return "1 week ago"
        } else if days < 30 {
            return "\(days / 7) weeks ago"
        } else {
            return "\(days / 30) months ago"
        }
    }

    var nudgeGroupLabel: String {
        let cal = Calendar.current
        if cal.isDateInToday(self) { return "Today" }
        if cal.isDateInYesterday(self) { return "Yesterday" }
        let days = cal.dateComponents([.day], from: self, to: .now).day ?? 0
        return days < 7 ? "This week" : "Earlier"
    }
}
