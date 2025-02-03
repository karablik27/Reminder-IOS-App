import Foundation
import SwiftData

@Model
class Event {
    var id: UUID
    var title: String
    var date: Date
    var isBookmarked: Bool
    var icon: String
    
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
    
    init(id: UUID = UUID(), title: String, date: Date, isBookmarked: Bool = false, icon: String) {
        self.id = id
        self.title = title
        self.date = date
        self.isBookmarked = isBookmarked
        self.icon = icon
    }
}
