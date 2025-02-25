import SwiftUI
import SwiftData

private enum Constants {
    enum TabBar {
        static let height: CGFloat = UIScreen.main.bounds.height * 0.1
        static let iconSize: CGFloat = UIScreen.main.bounds.width * 0.06
        static let plusButtonSize: CGFloat = UIScreen.main.bounds.width * 0.15
        static let cornerRadius: CGFloat = UIScreen.main.bounds.width * 0.09
        static let shadowRadius: CGFloat = UIScreen.main.bounds.width * 0.025
        static let shadowOpacity: Double = 0.15
        static let strokeWidth: CGFloat = UIScreen.main.bounds.width * 0.007
        static let plusButtonOffset: CGFloat = UIScreen.main.bounds.height * -0.03
    }
    
    enum Colors {
        static let mainGreen = Color(red: 0.8, green: 1, blue: 0.85, opacity: 0.9)
        static let background = Color(.systemBackground)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext // Получаем modelContext через Environment
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
            TabBarButton(image: "bookmark", index: 1, selectedTab: $selectedTab)
            
            NavigationLink(destination: AddEventView(viewModel: AddEventViewModel(modelContext: modelContext))) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 3)
                        )
                        .frame(width: Constants.TabBar.plusButtonSize,
                               height: Constants.TabBar.plusButtonSize)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.system(size: Constants.TabBar.iconSize, weight: .semibold))
                }
            }
            .offset(y: -Constants.TabBar.plusButtonSize/3)
            
            TabBarButton(image: "clock", index: 2, selectedTab: $selectedTab)
            TabBarButton(image: "gearshape", index: 3, selectedTab: $selectedTab)
        }
        .padding()
        .frame(height: Constants.TabBar.height)
        .background(Constants.Colors.mainGreen)
        .cornerRadius(Constants.TabBar.cornerRadius)
        .shadow(
            color: .black.opacity(0.15),
            radius: 10,
            x: 0,
            y: 0
        )
        .padding(.horizontal)
    }
}

struct TabBarButton: View {
    let image: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            Image(systemName: image)
                .font(.system(size: Constants.TabBar.iconSize * 1.3))
                .foregroundColor(selectedTab == index ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}
