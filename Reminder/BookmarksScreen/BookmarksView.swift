import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: BookmarksViewModel

    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false

    @State private var showDeleteOptions = false
    @State private var showDeleteAllAlert = false
    @State private var showSearchView = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: BookmarksViewModel(modelContext: modelContext))
    }

    var body: some View {
        VStack(spacing: ConstantsMain.body.VStackspacing) {
            HeaderSectionView(title: "Bookmarks") {
                // Настройки, если нужны
            }
            .padding(.horizontal)
            .padding(.top, ConstantsMain.body.headerSectionPadding)

            SortSectionView(
                selectedType: viewModel.selectedEventType.rawValue,
                selectedSortOption: viewModel.selectedSortOption.rawValue,
                isTypeExpanded: isTypeExpanded,
                isSortExpanded: isSortExpanded,
                toggleSortAction: { viewModel.toggleSortDirection() },
                typeMenuAction: {
                    isTypeExpanded.toggle()
                    showTypeMenu = true
                },
                sortMenuAction: {
                    isSortExpanded.toggle()
                    showSortMenu = true
                },
                deleteAction: { showDeleteOptions = true },
                searchAction: { showSearchView = true }
            )
            .padding(.horizontal)

            contentSection
        }
        .environment(\.modelContext, modelContext)
        .sheet(isPresented: $showTypeMenu, onDismiss: {
            isTypeExpanded = false
            viewModel.loadBookmarks()
        }) {
            TypeSelectionMenu(isPresented: $showTypeMenu,
                              selectedType: $viewModel.selectedEventType)
        }
        .sheet(isPresented: $showSortMenu, onDismiss: {
            isSortExpanded = false
            viewModel.loadBookmarks()
        }) {
            SortSelectionMenu(isPresented: $showSortMenu,
                              selectedSort: $viewModel.selectedSortOption)
        }
        .fullScreenCover(isPresented: $showSearchView) {
            BookmarksSearchView(viewModel: viewModel, isSearchActive: $showSearchView)
                .environment(\.modelContext, modelContext)
        }
        .confirmationDialog("Delete Bookmarked Events", isPresented: $showDeleteOptions, titleVisibility: .visible) {
            Button("Delete All Bookmarked Events", role: .destructive) {
                showDeleteAllAlert = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all bookmarked events?")
        }
        .alert("Do you want to delete all bookmarked events?", isPresented: $showDeleteAllAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteAllBookmarkedEvents()
            }
            Button("Don't delete", role: .cancel) { }
        } message: {
            Text("When all bookmarked events are deleted, all data about them will be erased without the possibility of recovery.")
        }
        .onAppear { viewModel.loadBookmarks() }
        .environmentObject(viewModel)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: ConstantsMain.TabBar.height)
        }
    }

    private var contentSection: some View {
        if viewModel.filteredModels.isEmpty {
            AnyView(
                VStack(spacing: ConstantsMain.contentSection.VStackspacing) {
                    Spacer(minLength: ConstantsMain.contentSection.spacer)
                    Text("No bookmarks yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Bookmark your first event on the main screen")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            )
        } else {
            AnyView(
                List {
                    ForEach(viewModel.filteredModels, id: \.id) { model in
                        GeometryReader { geo in
                            EventCellView(
                                model: model,
                                toggleBookmark: { viewModel.toggleBookmark(for: $0) },
                                timeLeftString: { viewModel.timeLeftString(for: $0) },
                                editDestination: {
                                    AnyView(
                                        EditEventView(viewModel: EditEventViewModel(modelContext: modelContext, event: model))
                                            .environmentObject(viewModel)
                                    )
                                }
                            )
                            .adjustableOpacity(tabBarHeight: ConstantsMain.TabBar.height, margin: 8)
                            .contentShape(Rectangle())
                        }
                        .frame(height: ConstantsMain.contentSection.frameHeight)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteEvent(model)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            )
        }
    }
}
