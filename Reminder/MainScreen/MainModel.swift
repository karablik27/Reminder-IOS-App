import Foundation
import SwiftData

enum EventType: String, Codable, CaseIterable {
    case allEvents = "All events"
    case holidays = "Holidays"
    case birthdays = "Birthdays"
    case study = "Study"
    case movies = "Movies"
    case other = "Other"
}

enum FirstRemind : String, Codable, CaseIterable {
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

enum ReminderFrequency: String, Codable, CaseIterable {
    case everyHour = "Every 1 hour"
    case everyDay = "Every 1 day"
    case everyWeek = "Every 1 week"
}

@Model
class MainModel {
    @Attribute var id: UUID
    @Attribute var title: String
    @Attribute var date: Date
    @Attribute var icon: String
    @Attribute var type: EventType
    @Attribute var isBookmarked: Bool = false
    @Attribute var information: String
    @Attribute var firstRemind: FirstRemind
    @Attribute var howOften: ReminderFrequency

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

    init(id: UUID = UUID(), title: String, date: Date, icon: String, type: EventType = .allEvents, isBookmarked: Bool = false, information: String = "", firstRemind: FirstRemind = .oneDayBefore, howOften: ReminderFrequency = .everyHour) {
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

    // Переносим данные из AddEventModel в MainModel
    static func fromAddEventModel(addEventModel: AddEventModel) -> MainModel {
        return MainModel(
            id: UUID(),
            title: addEventModel.title,
            date: addEventModel.date,
            icon: addEventModel.icon,
            type: EventType(rawValue: addEventModel.type.rawValue) ?? .allEvents,
            information: addEventModel.information,
            firstRemind: FirstRemind(rawValue: addEventModel.firstRemind.rawValue) ?? .oneDayBefore,
            howOften: ReminderFrequency(rawValue: addEventModel.howOften.rawValue) ?? .everyHour
        )
    }
}


