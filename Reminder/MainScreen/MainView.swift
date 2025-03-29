import SwiftUI
import SwiftData

private enum Constants {
    enum Layout {
        static let cornerRadius: CGFloat = 25
        static let iconSize: CGFloat = 60
        static let padding: CGFloat = 16
        static let emptyStateSpacing: CGFloat = 10
        static let emptyStateVerticalPadding: CGFloat = 0
    }
    enum Colors {
        static let background = Color(.systemBackground)
        static let mainGreen = Color(red: 0.8, green: 1, blue: 0.85, opacity: 0.9)
    }
    enum Text {
        static let titleSize: CGFloat = 34
        static let subtitleSize: CGFloat = 17
    }
    enum TabBar {
        static let height: CGFloat = 64
        static let extraHeight: CGFloat = 80
    }
}

struct MainView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext
    
    @State private var showTypeMenu = false
    @State private var showSortMenu = false
    @State private var isTypeExpanded = false
    @State private var isSortExpanded = false
    @State private var showDeleteOptions = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                // Фон экрана
                Constants.Colors.background.ignoresSafeArea()
                
                // Основной контент
                VStack(spacing: 0) {
                    // -- Заголовок
                    headerSection
                        // Уменьшаем отступы
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    // -- Блок сортировки
                    sortSection
                        // Тоже уменьшаем/убираем лишние отступы
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    
                    // Divider под сортировкой
                    Divider()
                        .frame(height: 1)
                        .background(Color(.systemGray4))
                        .padding(.bottom, 4)
                    
                    contentSection
                }
                // Отступ снизу, чтобы контент не налез на таббар
                .padding(.bottom, Constants.TabBar.height)
                
                // «Прямоугольник» для фона под таббаром + нижний Divider
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Нижний Divider (если нужен)
                    Divider()
                        .frame(height: 1)
                        .background(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(Constants.Colors.background)
                        .frame(height: Constants.TabBar.height + Constants.TabBar.extraHeight)
                        .ignoresSafeArea(edges: .horizontal)
                }
                .ignoresSafeArea(edges: .bottom)
                
                // Таббар поверх
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .environment(\.modelContext, modelContext)
            // Меню выбора типа
            .sheet(isPresented: $showTypeMenu, onDismiss: {
                isTypeExpanded = false
                viewModel.loadEvents()
            }) {
                TypeSelectionMenu(isPresented: $showTypeMenu, selectedType: $viewModel.selectedEventType)
            }
            // Меню выбора сортировки
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
                viewModel.loadEvents()
            }) {
                SortSelectionMenu(isPresented: $showSortMenu, selectedSort: $viewModel.selectedSortOption)
            }
            // Диалог удаления
            .confirmationDialog("Delete Events", isPresented: $showDeleteOptions) {
                Button("Delete All Events", role: .destructive) {
                    viewModel.deleteAllEvents()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .onAppear {
            viewModel.loadEvents()
        }
        .environmentObject(viewModel)
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        HStack {
            Text("Events")
                .font(.system(size: Constants.Text.titleSize, weight: .bold))
            Spacer()
            Button(action: {
                // Поиск
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.primary)
                    .padding(10)
            }
        }
    }
    
    private var sortSection: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.toggleSortDirection()
            }) {
                Image(systemName: viewModel.isAscending ? "arrow.up.arrow.down" : "arrow.up.arrow.down")
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
            }
            
            Button(action: {
                isTypeExpanded.toggle()
                showTypeMenu = true
            }) {
                HStack {
                    Text(viewModel.selectedEventType.rawValue)
                        .foregroundColor(.primary)
                    Image(systemName: isTypeExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Button(action: {
                isSortExpanded.toggle()
                showSortMenu = true
            }) {
                HStack {
                    Text(viewModel.selectedSortOption.rawValue)
                        .foregroundColor(.primary)
                    Image(systemName: isSortExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Button(action: {
                showDeleteOptions = true
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }
            Spacer()
        }
    }
    
    private var contentSection: some View {
        Group {
            if viewModel.filteredModels.isEmpty {
                VStack(spacing: Constants.Layout.emptyStateSpacing) {
                    Spacer(minLength: Constants.Layout.emptyStateVerticalPadding)
                    Text("No events yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Add your first event using + button")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                List {
                    ForEach(viewModel.filteredModels.indices, id: \.self) { i in
                        let model = viewModel.filteredModels[i]
                        
                        VStack(spacing: 0) {
                            HStack {
                                if let iconData = model.iconData,
                                   let uiImage = UIImage(data: iconData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .padding(.leading, 10)
                                        .padding(.trailing, 8)
                                } else {
                                    Image(model.icon)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .padding(.leading, 10)
                                        .padding(.trailing, 8)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(model.title)
                                        .font(.headline)
                                    Text("\(model.dateFormatted) \(model.dayOfWeek)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(viewModel.timeLeftString(for: model))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .offset(x: -8)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(Constants.Layout.cornerRadius)
                            .shadow(radius: 5)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
