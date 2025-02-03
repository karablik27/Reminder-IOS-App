import SwiftUI
import SwiftData
import UserNotifications

// MARK: - Constants
private extension WelcomeView {
    enum Constants {
        enum VStack {
            static let spacing: CGFloat = 20
        }
        
        enum Icon {
            static let frameHeight: CGFloat = 100
        }
        
        enum Button {
            static let backgroundColor = Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8)
            static let cornerRadius: CGFloat = 10
            static let horizontalPadding: CGFloat = 40
            static let verticalPadding: CGFloat = 10
            static let frameWidth: CGFloat = 200
            static let frameHeight: CGFloat = 50
            static let offsetY: CGFloat = 30
        }
        
        enum Text {
            static let fontSize: CGFloat = 20
            static let horizontalPadding: CGFloat = 100
            static let topPadding: CGFloat = -400
            static let offsetX: CGFloat = 100
            static let offsetY: CGFloat = -100
        }
        
        enum HStack {
            static let spacing: CGFloat = 8
            static let bottomPadding: CGFloat = 20
            static let offsetY: CGFloat = 80
        }
        
        enum Circle {
            static let size: CGFloat = 10
            static let activeColor = Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8)
            static let inactiveColor = Color.gray
        }
    }
}

struct WelcomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: WelcomeViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showNotificationAlert = false
    @State private var notificationPermissionGranted = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: WelcomeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(viewModel.slides.indices, id: \.self) { index in
                    let slide = viewModel.slides[index]
                    
                    VStack(spacing: Constants.VStack.spacing) {
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
                            .frame(height: Constants.Icon.frameHeight)
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
                            .background(Constants.Button.backgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .offset(y: Constants.Button.offsetY)
                            .alert(isPresented: $showNotificationAlert) {
                                if notificationPermissionGranted {
                                    return Alert(title: Text("Notifications Enabled"), message: Text("You will now receive notifications."), dismissButton: .default(Text("OK")))
                                } else {
                                    return Alert(title: Text("Notifications Denied"), message: Text("You can enable notifications in settings."), dismissButton: .default(Text("OK")))
                                }
                            }
                        }
                        
                        if slide.number == 4 {
                            Text("Search: Allows you to find reminders using keywords in the title, description, or other attributes.")
                                .font(.system(size: Constants.Text.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .padding(.horizontal, Constants.Text.horizontalPadding)
                                .padding(.top, Constants.Text.topPadding)
                                .offset(x: Constants.Text.offsetX, y: Constants.Text.offsetY)
                        }
                        
                        if slide.number == 4 {
                            Text("Sort: Helps you organize your reminders by date, name, or other parameters.")
                                .font(.system(size: Constants.Text.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .padding(.horizontal, Constants.Text.horizontalPadding)
                                .padding(.top, Constants.Text.topPadding)
                                .offset(x: Constants.Text.offsetX, y: Constants.Text.offsetY + 150)
                        }

                        HStack(spacing: Constants.HStack.spacing) {
                            ForEach(viewModel.slides.indices, id: \.self) { i in
                                Circle()
                                    .fill(i == viewModel.currentPage ? Constants.Circle.activeColor : Constants.Circle.inactiveColor)
                                    .frame(width: Constants.Circle.size, height: Constants.Circle.size)
                            }
                        }
                        .padding(.bottom, Constants.HStack.bottomPadding)
                        .offset(y: Constants.HStack.offsetY)

                        if index < viewModel.slides.count - 1 {
                            Button("Next") {
                                withAnimation {
                                    viewModel.nextPage()
                                }
                            }
                            .padding(.horizontal, Constants.Button.horizontalPadding)
                            .padding(.vertical, Constants.Button.verticalPadding)
                            .background(Constants.Button.backgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .frame(width: Constants.Button.frameWidth, height: Constants.Button.frameHeight)
                            .offset(y: Constants.Button.offsetY)
                        } else {
                            Button("Get Started!") {
                                viewModel.markWelcomeAsSeen()
                                dismiss()
                            }
                            .padding(.horizontal, Constants.Button.horizontalPadding)
                            .padding(.vertical, Constants.Button.verticalPadding)
                            .background(Constants.Button.backgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Button.cornerRadius)
                            .frame(width: Constants.Button.frameWidth, height: Constants.Button.frameHeight)
                            .offset(y: Constants.Button.offsetY)
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
                        viewModel.markWelcomeAsSeen()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
    
    func requestNotificationPermission() {
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
    WelcomeView(modelContext: try! ModelContainer(for: WelcomeModel.self).mainContext)
}
