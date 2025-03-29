enum EventTypeMain: String, Codable, CaseIterable {
    case allEvents = "All events"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case other = "Other"
}

enum EventTypeAddEvent: String, Codable, CaseIterable {
    case none = "None"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case other = "Other"
}

enum SortOption: String, CaseIterable {
    case byDate = "By date"
    case byName = "By name"
}
