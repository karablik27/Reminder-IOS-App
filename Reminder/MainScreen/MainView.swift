import SwiftUI
import SwiftData
import Combine

private enum Constants {
    enum Layout {
        static let cornerRadius: CGFloat = 25
        static let iconSize: CGFloat = UIScreen.main.bounds.width * 0.15
        static let padding: CGFloat = UIScreen.main.bounds.width * 0.04
        static let emptyStateSpacing: CGFloat = UIScreen.main.bounds.height * 0.01
        static let emptyStateVerticalPadding: CGFloat = UIScreen.main.bounds.height * 0.0001
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

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
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
                                .foregroundColor(.black)
                                .frame(width: 25, height: 25)
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
                            .cornerRadius(15)
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
                            .cornerRadius(15)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if viewModel.models.isEmpty {
                        VStack(spacing: Constants.Layout.emptyStateSpacing) {
                            Spacer(minLength: Constants.Layout.emptyStateVerticalPadding)
                            Text("No events yet")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("Add your first event using + button")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(viewModel.models) { model in
                                EventRow(model: model)
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
            .sheet(isPresented: $showTypeMenu, onDismiss: {
                isTypeExpanded = false
            }) {
                TypeSelectionMenu(
                    isPresented: $showTypeMenu,
                    selectedType: $viewModel.selectedEventType
                )
            }
            .sheet(isPresented: $showSortMenu, onDismiss: {
                isSortExpanded = false
            }) {
                SortSelectionMenu(
                    isPresented: $showSortMenu,
                    selectedSort: $viewModel.selectedSortOption
                )
            }
        }
    }
}

struct EventRow: View {
    let model: MainModel
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "bookmark")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 4)
            
            Image(systemName: model.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)
                Text("\(model.dateFormatted) \(model.dayOfWeek).")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(model.daysLeft) days")
                .font(.subheadline)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}



#Preview {
    MainView(modelContext: try! ModelContainer(for: MainModel.self).mainContext)
}
