import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Int = 0
    @StateObject var mainViewModel: MainViewModel

    init(modelContext: ModelContext) {
        _mainViewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedTab {
                case 0:
                    MainView(modelContext: modelContext)
                case 1:
                    BeautifulDatesView(modelContext: modelContext)
                case 2:
                    BookmarksView(modelContext: modelContext)
                case 3:
                    HistoryView(modelContext: modelContext)
                default:
                    MainView(modelContext: modelContext)
                }
            }
            .overlay(
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal),
                alignment: .bottom
            )
        }
        .environmentObject(mainViewModel)
    }
}
