// MARK: - EventTypeMain
enum EventTypeMain: String, Codable, CaseIterable {
    case allEvents = "All events"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case anniversary = "Anniversary"
    case travel = "Travel"
    case concerts = "Concerts"
    case goals = "Goals"
    case health = "Health"
    case meetings = "Meetings"
    case reminders = "Reminders"
    case work = "Work"
    case shopping = "Shopping"
    case romantic = "Romantic"
    case firstTime = "FirstTime"
    case wishDate = "WishDate"
    case memorable = "Memorable"
    case other = "Other"
}

// MARK: - EventTypeAddEvent
enum EventTypeAddEvent: String, Codable, CaseIterable {
    case none = "None"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case anniversary = "Anniversary"
    case travel = "Travel"
    case concerts = "Concerts"
    case goals = "Goals"
    case health = "Health"
    case meetings = "Meetings"
    case reminders = "Reminders"
    case work = "Work"
    case shopping = "Shopping"
    case romantic = "Romantic"
    case firstTime = "FirstTime"
    case wishDate = "WishDate"
    case memorable = "Memorable"
    case other = "Other"
}

// MARK: - SortOption
enum SortOption: String, CaseIterable {
    case byDate = "By date"
    case byName = "By name"
}
