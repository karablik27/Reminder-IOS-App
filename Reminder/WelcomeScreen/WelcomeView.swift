import SwiftUI
import SwiftData
import UserNotifications

struct WelcomeView: View {
    // MARK: - Constants
    private enum Constants {
        enum Layout {
            static let vStackSpacing: CGFloat = UIScreen.main.bounds.height * 0.02
            static let zStackHeight: CGFloat = UIScreen.main.bounds.height * 0.12
        }
        
        enum Button {
            static let cornerRadius: CGFloat = 10
            static let width: CGFloat = UIScreen.main.bounds.width * 0.5
            static let height: CGFloat = UIScreen.main.bounds.height * 0.06
            static let offsetY: CGFloat = UIScreen.main.bounds.height * 0.03
            static let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.05
            static let verticalPadding: CGFloat = UIScreen.main.bounds.height * 0.01
            static let navigationOffsetY: CGFloat = -UIScreen.main.bounds.height * 0.05
        }
        
        enum Colors {
            static let mainGreen = Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8)
        }
        
        enum Search {
            static let fontSize: CGFloat = UIScreen.main.bounds.width * 0.045
            static let horizontalPadding: CGFloat = UIScreen.main.bounds.width * 0.1
            static let offsetX: CGFloat = UIScreen.main.bounds.width * 0.24
            static let offsetY: CGFloat = -UIScreen.main.bounds.height * 0.35
            static let sortOffsetY: CGFloat = -UIScreen.main.bounds.height * 0.18
            static let maxTextWidth: CGFloat = UIScreen.main.bounds.width * 0.52
        }
        
        enum Dots {
            static let spacing: CGFloat = UIScreen.main.bounds.width * 0.02
            static let bottomPadding: CGFloat = UIScreen.main.bounds.height * 0.02
            static let offsetY: CGFloat = UIScreen.main.bounds.height * 0.08
            static let size: CGFloat = UIScreen.main.bounds.width * 0.025
        }
        
        enum CloseButton {
            static let fontSize: CGFloat = UIScreen.main.bounds.width * 0.05
        }
    }
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: WelcomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showNotificationAlert = false
    @State private var notificationPermissionGranted = false
    @State private var showMainView = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: WelcomeViewModel(modelContext: modelContext))
    }
    
    // MARK: - Body
    var body: some View {
        if showMainView {
            MainView(modelContext: modelContext)
        } else {
            welcomeContent
        }
    }
    
    private var welcomeContent: some View {
        ZStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(viewModel.slides.indices, id: \.self) { index in
                    let slide = viewModel.slides[index]
                    
                    VStack(spacing: Constants.Layout.vStackSpacing) {
                        if !slide.icons.isEmpty {
                            ZStack {
                                ForEach(slide.icons) { icon in
                                    Image(systemName: icon.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: icon.size.width, height: icon.size.height)
                                        .offset(icon.offset)
                                }
                            }
                            .frame(height: Constants.Layout.zStackHeight)
                        }
                        
                        ForEach(slide.slideTitles) { slideTitle in
                            Text(slideTitle.text)
                                .font(slideTitle.font)
                                .foregroundColor(slideTitle.color)
                                .offset(slideTitle.offset)
                                .multilineTextAlignment(.center)
                        }
                        
                        ForEach(slide.slideTexts) { slideText in
                            Text(slideText.text)
                                .font(slideText.font)
                                .foregroundColor(slideText.color)
                                .offset(slideText.offset)
                                .multilineTextAlignment(slideText.alignment)
                        }
                        
                        if slide.number == 3 {
                            Button("Allow Notifications") {
                                requestNotificationPermission()
                            }
                            .padding()
                            .background(Constants.Colors.mainGreen)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .offset(y: Constants.Button.offsetY)
                            .alert(isPresented: $showNotificationAlert) {
                                if notificationPermissionGranted {
                                    return Alert(
                                        title: Text("Notifications Enabled"),
                                        message: Text("You will now receive notifications."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                } else {
                                    return Alert(
                                        title: Text("Notifications Denied"),
                                        message: Text("You can enable notifications in settings."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if slide.number == 4 {
                            Text("Search: Allows you to find reminders using keywords in the title, description, or other attributes.")
                                .font(.system(size: Constants.Search.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: Constants.Search.maxTextWidth, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Constants.Search.horizontalPadding)
                                .offset(x: Constants.Search.offsetX, y: Constants.Search.offsetY)

                            Text("Sort: Helps you organize your reminders by date, name, or other parameters.")
                                .font(.system(size: Constants.Search.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: Constants.Search.maxTextWidth, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Constants.Search.horizontalPadding)
                                .offset(x: Constants.Search.offsetX, y: Constants.Search.sortOffsetY)
                        }
                        
                        HStack(spacing: Constants.Dots.spacing) {
                            ForEach(viewModel.slides.indices, id: \.self) { i in
                                Circle()
                                    .fill(i == viewModel.currentPage ? Constants.Colors.mainGreen : Color.gray)
                                    .frame(width: Constants.Dots.size, height: Constants.Dots.size)
                            }
                        }
                        .padding(.bottom, Constants.Dots.bottomPadding)
                        .offset(y: Constants.Dots.offsetY)
                        
                        if index < viewModel.slides.count - 1 {
                            Button("Next") {
                                withAnimation {
                                    viewModel.nextPage()
                                }
                            }
                            .frame(width: Constants.Button.width, height: Constants.Button.height)
                            .background(Constants.Colors.mainGreen)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .offset(y: Constants.Button.navigationOffsetY)
                        } else {
                            Button("Get Started!") {
                                completeWelcome()
                            }
                            .frame(width: Constants.Button.width, height: Constants.Button.height)
                            .background(Constants.Colors.mainGreen)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .offset(y: Constants.Button.navigationOffsetY)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        completeWelcome()
                    }) {
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(.black)
                            .font(.system(size: Constants.CloseButton.fontSize))
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func completeWelcome() {
        isFirstLaunch = false
        viewModel.markWelcomeAsSeen()
        withAnimation {
            showMainView = true
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                notificationPermissionGranted = granted
                showNotificationAlert = true
            }
        }
    }
}

#Preview {
    WelcomeView(modelContext: try! ModelContainer(for: Event.self).mainContext)
}