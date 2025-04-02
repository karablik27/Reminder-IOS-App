import SwiftUI
import SwiftData

// MARK: - Constants
private enum Constants {
    
    enum body {
        static let VStackspacing: CGFloat = 0
        static let headerSectionPadding: CGFloat = 8
    }
    
    enum Text {
        static let subtitleSize: CGFloat = 16
        static let titleSize: CGFloat = 32
    }
    
    enum headerSection {
        static let iconSize: CGFloat = 24
    }
    
    enum sortSection {
        static let spacing: CGFloat = 8
        static let paddingHorizontal: CGFloat = 8
        static let paddingVertical: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let iconSize: CGFloat = 24
    }
    
    enum contentSection {
        static let VStackspacing: CGFloat = 8
        static let spacer: CGFloat = 0
        static let frameHeight: CGFloat = 104
    }
    
    enum TabBar {
        static let selectedTab: Int = 0
        static let height: CGFloat = 64
        static let extraHeight: CGFloat = 72
    }
    
    enum eventCell {
        static let HStackspacing: CGFloat = 0
        static let shadowRadius: CGFloat = 4
        static let paddingLeading: CGFloat = 8
        static let paddingTrailing: CGFloat = 8
        static let paddingVertical: CGFloat = 16
        static let fontSizeIcon: CGFloat = 24
        static let cornerRadius: CGFloat = 24
        static let iconSize: CGFloat = 64
    }
}

// MARK: MainView
struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: HistoryViewModel
    
    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false
    
    @State private var showDeleteOptions = false
    @State private var showDeleteAllAlert = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Colors.background.ignoresSafeArea()
                
                VStack(spacing: Constants.body.VStackspacing) {
                    headerSection
                        .padding(.horizontal)
                        .padding(.top, Constants.body.headerSectionPadding)
                    
                    sortSection
                        .padding(.horizontal)
                    
                    contentSection
                }
            }
            .environment(\.modelContext, modelContext)
            
            .sheet(isPresented: $showTypeMenu, onDismiss: {
                isTypeExpanded = false
                viewModel.loadHistoryEvents()
            }) {
                TypeSelectionMenu(isPresented: $showTypeMenu,
                                  selectedType: $viewModel.selectedEventType)
            }
            
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
                viewModel.loadHistoryEvents()
            }) {
                SortSelectionMenu(isPresented: $showSortMenu,
                                  selectedSort: $viewModel.selectedSortOption)
            }
            
            .confirmationDialog("Delete History Events", isPresented: $showDeleteOptions, titleVisibility: .visible) {
                Button("Delete All History Events", role: .destructive) {
                    showDeleteAllAlert = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete all history events?")
            }
            .alert("Do you want to delete all history events?", isPresented: $showDeleteAllAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteAllHistoryEvents()
                }
                Button("Don't delete", role: .cancel) { }
            } message: {
                Text("When all history events are deleted, all data about them will be erased without the possibility of recovery.")
            }
        }
        .onAppear {
            viewModel.loadHistoryEvents()
        }
        .environmentObject(viewModel)
    }
}

// MARK: - Private subviews
private extension HistoryView {
    
    var headerSection: some View {
        HStack {
            Text("History")
                .font(.system(size: Constants.Text.titleSize, weight: .bold))
            Spacer()
            Button {
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.headerSection.iconSize, height: Constants.headerSection.iconSize)
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Sort Section
    private var sortSection: some View {
        HStack(spacing: Constants.sortSection.spacing) {
            
            HStack(spacing: Constants.sortSection.spacing) {
                
                Button {
                    viewModel.toggleSortDirection()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.primary)
                        .frame(width: Constants.sortSection.iconSize,
                               height: Constants.sortSection.iconSize)
                }
                
                Button {
                    isTypeExpanded.toggle()
                    showTypeMenu = true
                } label: {
                    HStack {
                        Text(viewModel.selectedEventType.rawValue)
                            .foregroundColor(.primary)
                        Image(systemName: isTypeExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, Constants.sortSection.paddingHorizontal)
                    .padding(.vertical, Constants.sortSection.paddingVertical)
                    .background(Color(.systemGray6))
                    .cornerRadius(Constants.sortSection.cornerRadius)
                }
                
                Button {
                    isSortExpanded.toggle()
                    showSortMenu = true
                } label: {
                    HStack {
                        Text(viewModel.selectedSortOption.rawValue)
                            .foregroundColor(.primary)
                        Image(systemName: isSortExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, Constants.sortSection.paddingHorizontal)
                    .padding(.vertical, Constants.sortSection.paddingVertical)
                    .background(Color(.systemGray6))
                    .cornerRadius(Constants.sortSection.cornerRadius)
                }
                
                Button {
                    showDeleteOptions = true
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.sortSection.iconSize, height: Constants.sortSection.iconSize)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.sortSection.iconSize, height: Constants.sortSection.iconSize) // Настройте по вкусу
                        .foregroundColor(.primary)
                }
            }
            
           
        }
    }
    
    // MARK: - Content Section
    var contentSection: some View {
        if viewModel.filteredModels.isEmpty {
            return AnyView(
                VStack(spacing: Constants.contentSection.VStackspacing) {
                    Spacer(minLength: Constants.contentSection.spacer)
                    Text("No history yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Finished events will appear here")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: Constants.TabBar.height)
                }
            )
        } else {
            return AnyView(
                List {
                    ForEach(viewModel.filteredModels, id: \.id) { model in
                        GeometryReader { geo in
                            eventCell(model: model)
                                .opacity(computeOpacity(geo))
                                .animation(.easeInOut, value: computeOpacity(geo))
                                .contentShape(Rectangle())
                        }
                        .frame(height: Constants.contentSection.frameHeight)
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
                    Color.clear.frame(height: Constants.TabBar.height)
                }
            )
        }
    }
    
    // MARK: - Compute Opacity
    private func computeOpacity(_ geo: GeometryProxy) -> Double {
        let cellFrame = geo.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        let safeAreaInsets = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first?.safeAreaInsets.bottom ?? 0
        let tabBarTop = screenHeight - (Constants.TabBar.height + safeAreaInsets)
        let margin: CGFloat = 8
        return cellFrame.maxY >= tabBarTop + margin ? 0 : 1
    }
    
    // MARK: - Event Cell
    func eventCell(model: MainModel) -> some View {
        HStack {
            Button {
                viewModel.toggleBookmark(for: model)
            } label: {
                Image(systemName: model.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: Constants.eventCell.fontSizeIcon))
                    .foregroundColor(model.isBookmarked ? .black : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, Constants.eventCell.paddingLeading)
            .padding(.trailing, Constants.eventCell.paddingTrailing)
            
            if let iconData = model.iconData, let uiImage = UIImage(data: iconData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: Constants.eventCell.iconSize, height: Constants.eventCell.iconSize)
                    .clipShape(Circle())
            } else {
                Image(model.icon)
                    .resizable()
                    .frame(width: Constants.eventCell.iconSize, height: Constants.eventCell.iconSize)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                Text("\(model.dateFormatted) \(model.dayOfWeek)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink {
                EditEventView(viewModel: EditEventViewModel(modelContext: modelContext, event: model))
                    .environmentObject(viewModel)
            } label: {
                HStack(spacing: Constants.eventCell.HStackspacing) {
                    Text(viewModel.timeLeftString(for: model))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .padding(.vertical, Constants.eventCell.paddingVertical)
        .background(Color.white)
        .cornerRadius(Constants.eventCell.cornerRadius)
        .shadow(radius: Constants.eventCell.shadowRadius)
    }
}
