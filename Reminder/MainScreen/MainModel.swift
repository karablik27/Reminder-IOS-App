import Foundation
import SwiftData



@Model
final class MainModel {
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

    var daysLeft: Int {
        let today = Calendar.current.startOfDay(for: Date())
        let eventDay = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: today, to: eventDay).day ?? 0
    }

    
    var dateFormatted: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" + "."
        return formatter.string(from: date)
    }
    
    var isBeautiful: Bool {
            return date.isBeautifulDate()
    }

    
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
