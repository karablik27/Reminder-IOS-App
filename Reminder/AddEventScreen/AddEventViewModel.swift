import SwiftUI
import SwiftData
import Foundation

class AddEventViewModel: ObservableObject {
    private var modelContext: ModelContext
    
    @Published var newTitle: String = ""
    @Published var newIcon: String = "default_icon"
    @Published var newEventDate: Date = Date()       // Дата (из CustomCalendarView)
    @Published var newEventTime: Date = Date()       // Время (из кастомного Time Picker)
    
    @Published var newType: EventTypeAddEvent = .none
    @Published var newInformation: String = ""
    @Published var newFirstRemind: FirstRemind = .oneHourBefore
    @Published var newHowOften: ReminderFrequency = .everyHour
    @Published var newIconData: Data? = nil
    
    @Published var nextEventNumber: Int = 1
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        updateNextEventNumber()
    }
    
    func updateNextEventNumber() {
        do {
            let allEvents = try modelContext.fetch(FetchDescriptor<MainModel>())
            nextEventNumber = allEvents.count + 1
        } catch {
            print("Ошибка при подсчёте уже существующих событий: \(error)")
            nextEventNumber = 1
        }
    }
    
    func updateIcon() {
        newIcon = defaultIcon(for: newType)
    }
    
    func defaultIcon(for newType: EventTypeAddEvent) -> String {
        switch newType {
        case .none:
            return ""
        case .holidays:
            return "holiday_icon"
        case .birthdays:
            return "birthday_icon"
        case .study:
            return "study_icon"
        case .movies:
            return "movie_icon"
        case .other:
            return "default_icon"
        }
    }
    
    private func convertToMainType(_ addType: EventTypeAddEvent) -> EventTypeMain {
        switch addType {
        case .none:       return .other
        case .holidays:   return .holidays
        case .birthdays:  return .birthdays
        case .study:      return .study
        case .movies:     return .movies
        case .other:      return .other
        }
    }
    
    /// Объединяем newEventDate (год, месяц, день) и newEventTime (час, минута) в один Date
    private func combineDateAndTime() -> Date {
        let calendar = Calendar.current
        
        // Компоненты дня, месяца, года — из newEventDate
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: newEventDate)
        // Компоненты часа, минут — из newEventTime
        let timeComponents = calendar.dateComponents([.hour, .minute], from: newEventTime)
        
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        
        // Если не удалось собрать, вернём newEventDate как fallback
        return calendar.date(from: merged) ?? newEventDate
    }
    
    func addEvent() {
        print("Adding event with the following data:")
        print("Title: \(newTitle)")
        print("Icon: \(newIcon)")
        print("Date (for day): \(newEventDate)")
        print("Time (for hour): \(newEventTime)")
        
        if newType == .none {
            print("User must select a valid type first!")
            return
        }
        
        let mainType = convertToMainType(newType)
        
        // Собираем финальную дату (день/месяц/год + час/минута)
        let finalDate = combineDateAndTime()
        
        let newEvent = MainModel(
            id: UUID(),
            title: newTitle,
            date: finalDate,
            icon: newIcon,
            type: mainType,
            isBookmarked: false,
            information: newInformation,
            firstRemind: newFirstRemind,
            howOften: newHowOften
        )
        
        if let data = newIconData, !data.isEmpty {
            newEvent.iconData = data
        }
        
        modelContext.insert(newEvent)
        
        do {
            try modelContext.save()
            print("Event saved successfully!")
            resetForm()
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
    
    private func resetForm() {
        newTitle = ""
        newIcon = "default_icon"
        newType = .none
        newInformation = ""
        newFirstRemind = .oneHourBefore
        newHowOften = .everyHour
        
        // Сбрасываем дату на "сейчас" (или Date()), время тоже
        newEventDate = Date()
        newEventTime = Date()
        
        updateNextEventNumber()
    }
    
    var displayedTitle: String {
        if newTitle.isEmpty {
            return "Event \(nextEventNumber)"
        } else {
            return newTitle
        }
    }
}
