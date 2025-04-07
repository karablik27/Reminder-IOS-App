enum EventTypeMain: String, Codable, CaseIterable {
    case allEvents = "All events"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case anniversary = "Anniversary"          // годовщины
    case travel = "Travel"                    // поездки, путешествия
    case concerts = "Concerts"                // концерты, фестивали
    case goals = "Goals"                      // личные цели, дедлайны
    case health = "Health"                    // визиты к врачу, здоровье
    case meetings = "Meetings"                // встречи
    case reminders = "Reminders"              // просто напоминания
    case work = "Work"                        // рабочие события
    case shopping = "Shopping"                // напоминания о покупках или скидках
    case romantic = "Romantic"                // свидания, важные моменты в отношениях
    case firstTime = "FirstTime"
    case wishDate = "WishDate"
    case memorable = "Memorable"
    case other = "Other"
}

enum EventTypeAddEvent: String, Codable, CaseIterable {
    case none = "None"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case anniversary = "Anniversary"          // годовщины
    case travel = "Travel"                    // поездки, путешествия
    case concerts = "Concerts"                // концерты, фестивали
    case goals = "Goals"                      // личные цели, дедлайны
    case health = "Health"                    // визиты к врачу, здоровье
    case meetings = "Meetings"                // встречи
    case reminders = "Reminders"              // просто напоминания
    case work = "Work"                        // рабочие события
    case shopping = "Shopping"                // напоминания о покупках или скидках
    case romantic = "Romantic"                // свидания, важные моменты в отношениях
    case firstTime = "FirstTime"
    case wishDate = "WishDate"
    case memorable = "Memorable"
    case other = "Other"
}


enum SortOption: String, CaseIterable {
    case byDate = "By date"
    case byName = "By name"
}
