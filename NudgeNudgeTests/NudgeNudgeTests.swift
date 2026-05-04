import Testing
@testable import NudgeNudge

struct NudgeNudgeTests {
    @Test func nudgeScheduleDisplayName() {
        let daily = NudgeSchedule.daily(hour: 9, minute: 0)
        #expect(daily.displayName == "Daily at 09:00")

        let weekly = NudgeSchedule.weekly(weekday: 2, hour: 10, minute: 30)
        #expect(weekly.displayName.contains("10:30"))

        let interval = NudgeSchedule.interval(seconds: 3600)
        #expect(interval.displayName == "Every 1h")
    }
}
