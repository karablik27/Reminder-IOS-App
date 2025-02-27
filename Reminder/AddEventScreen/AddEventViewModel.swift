import SwiftUI
import Foundation
import SwiftData

class AddEventViewModel: ObservableObject {
    private var modelContext: ModelContext

    @Published var newTitle: String = ""
    @Published var newIcon: String = "App Icon"
    @Published var newType: Enums.EventType = .allEvents
    @Published var newInformation: String = ""
    @Published var newFirstRemind: Enums.FirstRemind = .oneDayBefore
    @Published var newHowOften: Enums.ReminderFrequency = .everyHour

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func updateIcon() {
        newIcon = defaultIcon(for: newType)
    }

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
}
