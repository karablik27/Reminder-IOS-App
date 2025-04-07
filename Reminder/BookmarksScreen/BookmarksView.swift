import SwiftUI
import SwiftData

// MARK: - BookmarksView
struct BookmarksView: View {

    // MARK: - Dependencies
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: BookmarksViewModel

    // MARK: - UI State
    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false
    @State private var showDeleteOptions = false
    @State private var showDeleteAllAlert = false
    @State private var showSearchView = false
    @State private var showSettings = false

    // MARK: - Init
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: BookmarksViewModel(modelContext: modelContext))
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: ConstantsMain.body.VStackspacing) {
            // MARK: Header
            HeaderSectionView(title: "Bookmarks".localized) {
                showSettings = true
            }
            .padding(.horizontal)
            .padding(.top, ConstantsMain.body.headerSectionPadding)

            // MARK: Sort Section
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

            // MARK: Content Section
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
        .navigationDestination(isPresented: $showSettings) {
            SettingsView(viewModel: SettingsViewModel(modelContext: modelContext))
        }
        .confirmationDialog("Delete Bookmarked Events".localized, isPresented: $showDeleteOptions, titleVisibility: .visible) {
            Button("Delete All Bookmarked Events".localized, role: .destructive) {
                showDeleteAllAlert = true
            }
            Button("Cancel".localized, role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete all bookmarked events?".localized)
        }
        .alert("Do you want to delete all bookmarked events?".localized, isPresented: $showDeleteAllAlert) {
            Button("Delete".localized, role: .destructive) {
                viewModel.deleteAllBookmarkedEvents()
            }
            Button("Don't delete".localized, role: .cancel) { }
        } message: {
            Text("When all bookmarked events are deleted, all data about them will be erased without the possibility of recovery.".localized)
        }
        .onAppear { viewModel.loadBookmarks() }
        .environmentObject(viewModel)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: ConstantsMain.TabBar.height)
        }
    }

    // MARK: - Content Section
    private var contentSection: some View {
        if viewModel.filteredModels.isEmpty {
            AnyView(
                VStack(spacing: ConstantsMain.contentSection.VStackspacing) {
                    Spacer(minLength: ConstantsMain.contentSection.spacer)
                    Text("No bookmarks yet".localized)
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Bookmark your first event on the main screen".localized)
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
                            .adjustableOpacity(tabBarHeight: ConstantsMain.TabBar.height, margin: ConstantsMain.contentSection.margin)
                            .contentShape(Rectangle())
                        }
                        .frame(height: ConstantsMain.contentSection.frameHeight)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteEvent(model)
                            } label: {
                                Label("Delete".localized, systemImage: "trash")
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
