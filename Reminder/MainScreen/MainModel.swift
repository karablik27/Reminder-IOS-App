import Foundation
import SwiftData

enum EventType: String, Codable, CaseIterable {
    case allEvents = "All events"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case other = "Other" // Добавили case other
}

@Model
class MainModel {
    var id: UUID
    var title: String
    var date: Date
    var isBookmarked: Bool
    var icon: String
    var type: EventType // Добавляем тип события
    
    var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
    
    var dateFormatted: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    init(id: UUID = UUID(), title: String, date: Date, isBookmarked: Bool = false, icon: String, type: EventType = .allEvents) { // Изменили значение по умолчанию на .allEvents
        self.id = id
        self.title = title
        self.date = date
        self.isBookmarked = isBookmarked
        self.icon = icon
        self.type = type
    }
}