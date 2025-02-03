import SwiftUI
import SwiftData

private enum Constants {
    enum Layout {
        static let cornerRadius: CGFloat = 25
        static let iconSize: CGFloat = UIScreen.main.bounds.width * 0.15
        static let padding: CGFloat = UIScreen.main.bounds.width * 0.04
        static let tabBarHeight: CGFloat = UIScreen.main.bounds.height * 0.1
    }
    
    enum Colors {
        static let mainGreen = Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8)
        static let background = Color(.systemBackground)
        static let tabBarBackground = Color(.systemGray6).opacity(0.95)
    }
    
    enum Text {
        static let titleSize: CGFloat = 34
        static let subtitleSize: CGFloat = 17
    }
}

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Events")
                            .font(.system(size: Constants.Text.titleSize, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    
                    // Sort options
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                        
                        Picker("Sort", selection: $viewModel.sortOption) {
                            ForEach(MainViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if viewModel.events.isEmpty {
                        VStack {
                            Spacer()
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
                            ForEach(viewModel.events) { event in
                                EventRow(event: event)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                VStack {
                    Spacer()
                    CustomTabBar()
                }
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "bookmark")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 4)
            
            Image(systemName: event.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text("\(event.dateFormatted) \(event.dayOfWeek).")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(event.daysLeft) days")
                .font(.subheadline)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(image: "list.bullet", action: {})
            TabBarButton(image: "bookmark", action: {})
            
            Button(action: {}) {
                ZStack {
                    Circle()
                        .foregroundColor(Constants.Colors.mainGreen)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .offset(y: -20)
            
            TabBarButton(image: "clock", action: {})
            TabBarButton(image: "gearshape", action: {})
        }
        .padding()
        .background(Constants.Colors.tabBarBackground)
        .cornerRadius(Constants.Layout.cornerRadius)
        .padding(.horizontal)
    }
}

struct TabBarButton: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: image)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainView(modelContext: try! ModelContainer(for: Event.self).mainContext)
} 
