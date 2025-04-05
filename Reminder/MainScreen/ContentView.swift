import SwiftUI
import SwiftData

struct ContentView: View {
    let modelContext: ModelContext
    @State private var selectedTab: Int = 0
    @StateObject var mainViewModel: MainViewModel
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _mainViewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            // Основной контент
            Group {
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
            // ⬇︎ Вставляем таб-бар как safeAreaInset ⬇︎
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal)
            }
        }
        .environmentObject(mainViewModel)
        .fullScreenCover(isPresented: Binding(
            get: { isFirstLaunch },
            set: { isFirstLaunch = $0 }
        )) {
            WelcomeView(modelContext: modelContext, onDismiss: {
                isFirstLaunch = false
            })
        }

    }
}
