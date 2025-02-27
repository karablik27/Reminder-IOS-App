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
        static let mainGreen = Color(red: 0.8, green: 1, blue: 0.85, opacity: 0.9)
        static let background = Color(.systemBackground)
    }
    enum Text {
        static let titleSize: CGFloat = 34
        static let subtitleSize: CGFloat = 17
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
    @State private var showAddEventView = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
        print("MainView initialized with modelContext: \(modelContext)")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("Events")
                            .font(.system(size: Constants.Text.titleSize, weight: .bold))
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.primary)
                                .padding(10)
                        }
                    }
                    .padding()

                    HStack(spacing: 12) {
                        Button(action: { viewModel.toggleSortDirection() }) {
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
                        Spacer()
                    }
                    .padding(.horizontal)
                    
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
                            ForEach(viewModel.filteredModels) { model in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(model.title)
                                            .font(.headline)
                                        Text("\(model.dateFormatted) \(model.dayOfWeek)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(model.daysLeft) days")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, Constants.Layout.padding)
                                .background(Color.white)
                                .cornerRadius(Constants.Layout.cornerRadius)
                                .shadow(radius: 5)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .environment(\.modelContext, modelContext)
            .sheet(isPresented: $showTypeMenu, onDismiss: {
                isTypeExpanded = false
                viewModel.loadEvents() // Обновляем события после изменения типа
            }) {
                TypeSelectionMenu(isPresented: $showTypeMenu, selectedType: $viewModel.selectedEventType)
            }
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
                viewModel.loadEvents() // Обновляем события после изменения сортировки
            }) {
                SortSelectionMenu(isPresented: $showSortMenu, selectedSort: $viewModel.selectedSortOption)
            }
            .sheet(isPresented: $showAddEventView, onDismiss: {
                viewModel.loadEvents() // Обновляем события после добавления
            }) {
                AddEventView(viewModel: AddEventViewModel(modelContext: modelContext))
            }
        }
        .onAppear {
            viewModel.loadEvents() // Загружаем события при появлении экрана
        }
    }
}

#Preview {
    MainView(modelContext: try! ModelContainer(for: MainModel.self).mainContext)
}
