import SwiftUI
import Foundation
import SwiftData

class AddEventViewModel: ObservableObject {
    private var modelContext: ModelContext

    // Все свойства теперь помечены как @Published, чтобы они были наблюдаемыми
    @Published var newTitle: String = ""
    @Published var newIcon: String = "App Icon"
    @Published var newType: Enums.EventType = .allEvents
    @Published var newInformation: String = ""
    @Published var newFirstRemind: Enums.FirstRemind = .oneDayBefore
    @Published var newHowOften: Enums.ReminderFrequency = .everyHour

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // Обновление иконки в зависимости от типа события
    func updateIcon() {
        newIcon = defaultIcon(for: newType)
    }

    // Метод для получения иконки в зависимости от типа события
    func defaultIcon(for newType: Enums.EventType) -> String {
        switch newType {
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
        case .allEvents:
            return "all_events_icon"
        }
    }

    // Добавление события в базу данных
    func addEvent() {
        print("Adding event with the following data:")
        print("Title: \(newTitle)")
        print("Icon: \(newIcon)")
        print("Date: \(Date())")
        print("Type: \(newType.rawValue)")
        print("Information: \(newInformation)")
        print("First Remind: \(newFirstRemind.rawValue)")
        print("How Often: \(newHowOften.rawValue)")

        let newEvent = MainModel(id: UUID(), title: newTitle, date: Date(), icon: newIcon, type: newType, isBookmarked: false, information: newInformation, firstRemind: newFirstRemind, howOften: newHowOften)
        
        modelContext.insert(newEvent)

        do {
            try modelContext.save()
            print("Event saved successfully!")
            resetForm()
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }

    // Удаление события
    func deleteEvent(event: MainModel) {
        modelContext.delete(event)

        do {
            try modelContext.save()
        } catch {
            print("Ошибка при удалении: \(error)")
        }
    }

    private func resetForm() {
        newTitle = ""
        newIcon = "App Icon"
        newType = .allEvents
        newInformation = ""
        newFirstRemind = .oneDayBefore
        newHowOften = .everyHour
    }

    func updateTitle(newTitle: String) {
        self.newTitle = newTitle
    }

    func updateInformation(newInformation: String) {
        self.newInformation = newInformation
    }


    func updateDate(newDate: Date) {
        print("Updated event date: \(newDate)")
    }

    func updateReminderFrequency(newFrequency: Enums.ReminderFrequency) {
        self.newHowOften = newFrequency
    }

    func updateFirstRemind(newReminder: Enums.FirstRemind) {
        self.newFirstRemind = newReminder
    }

    func updateEventType(newType: Enums.EventType) {
        self.newType = newType
        updateIcon()
    }
}
