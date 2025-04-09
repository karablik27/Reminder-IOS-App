import SwiftUI
import SwiftData

struct ContentView: View {
    
    // MARK: - Properties
    let modelContext: ModelContext
    @State private var selectedTab: Int = 0
    @StateObject var mainViewModel: EventsViewModel
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true

    // MARK: - Init
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _mainViewModel = StateObject(wrappedValue: EventsViewModel(modelContext: modelContext))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Group {
                switch selectedTab {
                case 0:
                    EventsView(modelContext: modelContext)
                case 1:
                    BeautifulDatesView(modelContext: modelContext)
                case 2:
                    BookmarksView(modelContext: modelContext)
                case 3:
                    HistoryView(modelContext: modelContext)
                default:
                    EventsView(modelContext: modelContext)
                }
            }
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
