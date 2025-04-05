import SwiftUI
import SwiftData

struct SearchView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var isSearchActive: Bool
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: SearchConstants.VStackSpacing) {
                SearchHeaderView(
                    title: "Events",
                    searchText: $viewModel.searchText,
                    placeholder: "Search events...",
                    leftButtonAction: { withAnimation { isSearchActive = false } },
                    rightButtonAction: { withAnimation { isSearchActive = false } }
                )
                
                if viewModel.searchResults.isEmpty {
                    Spacer()
                    Text("No events found")
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
                                    Label("Delete", systemImage: "trash")
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
