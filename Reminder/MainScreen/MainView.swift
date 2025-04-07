import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false
    @State private var showDeleteOptions = false
    @State private var showDeleteAllAlert = false
    @State private var showSearchView = false
    @State private var showSettings = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Colors.background.ignoresSafeArea()
                VStack(spacing: ConstantsMain.body.VStackspacing) {
                    HeaderSectionView(title: "Events".localized) {
                        showSettings = true
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
                viewModel.loadEvents()
            }) {
                TypeSelectionMenu(isPresented: $showTypeMenu, selectedType: $viewModel.selectedEventType)
            }
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
                viewModel.loadEvents()
            }) {
                SortSelectionMenu(isPresented: $showSortMenu, selectedSort: $viewModel.selectedSortOption)
            }
            .fullScreenCover(isPresented: $showSearchView) {
                SearchView(viewModel: viewModel, isSearchActive: $showSearchView)
                    .environment(\.modelContext, modelContext)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView(viewModel: SettingsViewModel(modelContext: modelContext))
            }
            .confirmationDialog("Delete Events".localized, isPresented: $showDeleteOptions, titleVisibility: .visible) {
                Button("Delete All Events".localized, role: .destructive) {
                    showDeleteAllAlert = true
                }
                Button("Cancel".localized, role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete all events?".localized)
            }
            .alert("Do you want to delete all events?".localized, isPresented: $showDeleteAllAlert) {
                Button("Delete".localized, role: .destructive) {
                    viewModel.deleteAllEvents()
                }
                Button("Don't delete".localized, role: .cancel) { }
            } message: {
                Text("When all events are deleted, all data about them will be erased without the possibility of recovery.".localized)
            }
        }
        .onAppear { viewModel.loadEvents() }
        .environmentObject(viewModel)
        
    }

    private var contentSection: some View {
        if viewModel.filteredModels.isEmpty {
            return AnyView(
                VStack(spacing: ConstantsMain.contentSection.VStackspacing) {
                    Spacer(minLength: ConstantsMain.contentSection.spacer)
                    Text("No events yet".localized)
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Add your first event using the + button".localized)
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
                                Label("Delete".localized, systemImage: "trash")
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
