// MARK: - FirstRemind
enum FirstRemind: String, Codable, CaseIterable {
    case fiveMinutesBefore = "5 minutes before"
    case fifthteenMinutesBefore = "15 minutes before"
    case thirtyMinutesBefore = "30 minutes before"
    case fortyfiveMinutesBefore = "45 minutes before"
    case oneHourBefore = "1 hour before"
    case twoHourBefore = "2 hour before"
    case threeHourBefore = "3 hour before"
    case fourHourBefore = "4 hour before"
    case fiveHourBefore = "5 hour before"
    case sixHourBefore = "6 hour before"
    case sevenHourBefore = "7 hour before"
    case eightHourBefore = "8 hour before"
    case nineHourBefore = "9 hour before"
    case tenHourBefore = "10 hour before"
    case elevenHourBefore = "11 hour before"
    case twelveHourBefore = "12 hour before"
    case thirteenHourBefore = "13 hour before"
    case fourteenHourBefore = "14 hour before"
    case fifteenHourBefore = "15 hour before"
    case sixteenHourBefore = "16 hour before"
    case seventeenHourBefore = "17 hour before"
    case oneDayBefore = "1 day before"
    case oneWeekBefore = "1 week before"
}

// MARK: - ReminderFrequency
enum ReminderFrequency: String, Codable, CaseIterable {
    case everyFiveSeconds = "Every 1 minute"
    case everyHour = "Every 1 hour"
    case everyDay = "Every 1 day"
    case everyWeek = "Every 1 week"
}
