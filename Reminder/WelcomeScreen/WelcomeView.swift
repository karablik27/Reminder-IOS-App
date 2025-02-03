import SwiftUI
import SwiftData
import UserNotifications

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
                    
                    VStack(spacing: 20) {
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
                            .frame(height: 100)
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
                            .background(Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .offset(x: 0, y: 30)
                            .alert(isPresented: $showNotificationAlert) {
                                if notificationPermissionGranted {
                                    return Alert(title: Text("Notifications Enabled"), message: Text("You will now receive notifications."), dismissButton: .default(Text("OK")))
                                } else {
                                    return Alert(title: Text("Notifications Denied"), message: Text("You can enable notifications in settings."), dismissButton: .default(Text("OK")))
                                }
                            }
                        }
                        

                        Spacer()
                        
                        if slide.number == 4 {
                            Text("Search: Allows you to find reminders using keywords in the title, description, or other attributes.")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .padding(.horizontal, 100)
                                .padding(.top, -400)
                                .offset(x:100, y: -100)

                        }
                        if slide.number == 4 {
                            Text("Sort: Helps you organize your reminders by date, name, or other parameters.")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(nil)
                                .padding(.horizontal, 100)
                                .padding(.top, -400)
                                .offset(x:100, y: 150)

                        }

                        HStack(spacing: 8) {
                            ForEach(viewModel.slides.indices, id: \.self) { i in
                                Circle()
                                    .fill(i == viewModel.currentPage ? Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8) : Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.bottom, 20)
                        .offset(x: 0, y: 80)

                        if index < viewModel.slides.count - 1 {
                            Button("Next") {
                                withAnimation {
                                    viewModel.nextPage()
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .frame(width: 200, height: 50)
                            .offset(x: 0, y: -40)
                        } else {
                            Button("Get Started!") {
                                viewModel.markWelcomeAsSeen()
                                dismiss()
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.0, green: 0.8, blue: 0.5, opacity: 0.8))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .frame(width: 200, height: 50)
                            .offset(x: 0, y: -40)
                            
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
                if granted {
                    notificationPermissionGranted = true
                } else {
                    notificationPermissionGranted = false
                }
                showNotificationAlert = true
            }
        }
    }
}

#Preview {
    WelcomeView(modelContext: try! ModelContainer(for: WelcomeModel.self).mainContext)
}


