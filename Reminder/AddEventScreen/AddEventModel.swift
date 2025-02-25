import Foundation
import SwiftData


enum Enums {
    
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
    
}


@Model
final class AddEventModel {
    @Attribute var icon: String
    @Attribute var title: String
    @Attribute var date: Date
    @Attribute var type: Enums.EventType
    @Attribute var information: String
    @Attribute var firstRemind: Enums.FirstRemind
    @Attribute var howOften: Enums.ReminderFrequency
    
    init(icon: String, title: String, date: Date, type: Enums.EventType, information: String, firstRemind: Enums.FirstRemind, howOften: Enums.ReminderFrequency) {
        
        self.title = title
        self.date = date
        self.type = type
        self.information = information
        self.firstRemind = firstRemind
        self.howOften = howOften
        self.icon = icon
    }
    
}
