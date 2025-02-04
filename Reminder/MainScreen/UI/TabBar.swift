import SwiftUI

private enum Constants {
    enum TabBar {
        static let height: CGFloat = UIScreen.main.bounds.height * 0.1
        static let iconSize: CGFloat = 24
        static let plusButtonSize: CGFloat = 60
        static let cornerRadius: CGFloat = 35
    }
    
    enum Colors {
        static let mainGreen = Color(red: 0.8, green: 1, blue: 0.85, opacity: 0.9)
        static let background = Color(.systemBackground)
    }
    
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(image: "list.bullet", index: 0, selectedTab: $selectedTab)
            TabBarButton(image: "bookmark", index: 1, selectedTab: $selectedTab)
            
            Button(action: {}) {
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
