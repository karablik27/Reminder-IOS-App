import SwiftUI
import SwiftData

@main
struct ReminderApp: App {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LoadingModel.self,
            WelcomeModel.self,
            MainModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .modelContainer(sharedModelContainer)
        }
    }
}
