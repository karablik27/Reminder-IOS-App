import SwiftUI
import SwiftData

struct BeautifulDatesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: BeautifulDatesViewModel

    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false
    @State private var showDeleteOptions = false
    @State private var showDeleteAllAlert = false
    @State private var showSearchView = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: BeautifulDatesViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Colors.background.ignoresSafeArea()
                VStack(spacing: ConstantsMain.body.VStackspacing) {
                    HeaderSectionView(title: "Beautiful Dates") {
                        // Действие для настроек (если требуется)
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
            }
            .environment(\.modelContext, modelContext)
            .sheet(isPresented: $showTypeMenu, onDismiss: {
                isTypeExpanded = false
                viewModel.loadBeautifulEvents()
            }) {
                TypeSelectionMenu(isPresented: $showTypeMenu,
                                  selectedType: $viewModel.selectedEventType)
            }
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
                viewModel.loadBeautifulEvents()
            }) {
                SortSelectionMenu(isPresented: $showSortMenu,
                                  selectedSort: $viewModel.selectedSortOption)
            }
            .fullScreenCover(isPresented: $showSearchView) {
                BeautifulDatesSearchView(viewModel: viewModel, isSearchActive: $showSearchView)
                    .environment(\.modelContext, modelContext)
            }
            .confirmationDialog("Delete Beautiful Events", isPresented: $showDeleteOptions, titleVisibility: .visible) {
                Button("Delete All Beautiful Events", role: .destructive) {
                    showDeleteAllAlert = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete all beautiful events?")
            }
            .alert("Delete Beautiful Events", isPresented: $showDeleteAllAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteAllBeautifulEvents()
                }
                Button("Don't delete", role: .cancel) { }
            } message: {
                Text("When all beautiful events are deleted, they cannot be recovered.")
            }
        }
        .onAppear { viewModel.loadBeautifulEvents() }
        .environmentObject(viewModel)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        if viewModel.filteredModels.isEmpty {
            return AnyView(
                VStack(spacing: ConstantsMain.contentSection.VStackspacing) {
                    Spacer(minLength: ConstantsMain.contentSection.spacer)
                    Text("No beautiful events yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Beautiful events will appear here")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: ConstantsMain.TabBar.height)
                }
            )
        } else {
            return AnyView(
                List {
                    ForEach(viewModel.filteredModels, id: \.id) { model in
                        GeometryReader { geo in
                            EventCellView(
                                model: model,
                                toggleBookmark: { viewModel.toggleBookmark(for: $0) },
                                timeLeftString: { viewModel.timeLeftString(for: $0) },
                                // Переход реализован только на тексте с оставшимся временем
                                editDestination: {
                                    AnyView(
                                        EditEventView(
                                            viewModel: EditEventViewModel(modelContext: modelContext, event: model)
                                        )
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
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: ConstantsMain.TabBar.height)
                }
            )
        }
    }
}
