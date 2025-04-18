import SwiftUI
import SwiftData

// MARK: - BookmarksSearchView
struct BookmarksSearchView: View {

    // MARK: - Properties
    @ObservedObject var viewModel: BookmarksViewModel
    @Binding var isSearchActive: Bool
    @Environment(\.modelContext) private var modelContext

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: SearchConstants.VStackSpacing) {
                // MARK: - Search Header
                SearchHeaderView(
                    title: "Bookmarks".localized,
                    searchText: $viewModel.searchText,
                    placeholder: "Search bookmarks...".localized,
                    dismissAction: { withAnimation { isSearchActive = false } })

                // MARK: - Empty State or Results
                if viewModel.searchResults.isEmpty {
                    Spacer()
                    Text("No bookmarks found".localized)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.searchResults, id: \.id) { event in
                            EventCellView(
                                model: event,
                                toggleBookmark: { viewModel.toggleBookmark(for: $0) },
                                timeLeftString: { viewModel.timeLeftString(for: $0) },
                                editDestination: {
                                    AnyView(
                                        EditEventView(
                                            viewModel: EditEventViewModel(modelContext: modelContext, event: event)
                                        )
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
