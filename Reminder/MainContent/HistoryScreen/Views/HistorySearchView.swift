import SwiftUI
import SwiftData

// MARK: - HistorySearchView
struct HistorySearchView: View {

    // MARK: - Properties
    @State private var selectedTab: Int = ConstantsMain.TabBar.selectedTab
    @ObservedObject var viewModel: HistoryViewModel
    @Binding var isSearchActive: Bool
    @Environment(\.modelContext) private var modelContext

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: SearchConstants.VStackSpacing) {

                // MARK: - Search Header
                SearchHeaderView(
                    title: "History".localized,
                    searchText: $viewModel.searchText,
                    placeholder: "Search history...".localized,
                    dismissAction: { withAnimation { isSearchActive = false } }
                )

                // MARK: - Search Results
                if viewModel.searchResults.isEmpty {
                    // MARK: - Empty State
                    Spacer()
                    Text("No history events found".localized)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    // MARK: - Results List
                    List {
                        ForEach(viewModel.searchResults, id: \.id) { event in
                            EventCellView(
                                model: event,
                                toggleBookmark: { viewModel.toggleBookmark(for: $0) },
                                timeLeftString: { viewModel.timeLeftString(for: $0) },
                                editDestination: {
                                    AnyView(
                                        EditEventView(viewModel: EditEventViewModel(modelContext: modelContext, event: event))
                                            .environmentObject(viewModel)
                                    )
                                }
                            )
                            .frame(height: ConstantsMain.contentSection.frameHeight)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteEvent(event)
                                } label: {
                                    Label("Delete".localized, systemImage: "trash")
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
