import Foundation
import SwiftData


@Model
final class MainModel {
    // MARK: - Attributes
    @Attribute var id: UUID
    @Attribute var title: String
    @Attribute var date: Date
    @Attribute var icon: String
    @Attribute var type: EventTypeMain
    @Attribute var isBookmarked: Bool = false
    @Attribute var information: String
    @Attribute var firstRemind: FirstRemind
    @Attribute var howOften: ReminderFrequency
    @Attribute var iconData: Data? = nil

    // MARK: - Computed Properties
    
    /// Returns the number of days left until the event.
    var daysLeft: Int {
        let today = Calendar.current.startOfDay(for: Date())
        let eventDay = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: today, to: eventDay).day ?? 0
    }
    
    /// Formats the event date as a numeric string without time.
    var dateFormatted: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    /// Returns the abbreviated day of the week for the event date.
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" + "."
        return formatter.string(from: date)
    }
    
    /// Checks if the event date is considered "beautiful" based on custom logic.
    var isBeautiful: Bool {
        return date.isBeautifulDate()
    }
    
    // MARK: - Initializer
    init(id: UUID = UUID(), title: String, date: Date, icon: String, type: EventTypeMain = .allEvents, isBookmarked: Bool = false, information: String = "", firstRemind: FirstRemind = .oneDayBefore, howOften: ReminderFrequency = .everyHour) {
        self.id = id
        self.title = title
        self.date = date
        self.icon = icon
        self.type = type
        self.isBookmarked = isBookmarked
        self.information = information
        self.firstRemind = firstRemind
        self.howOften = howOften
    }
}
