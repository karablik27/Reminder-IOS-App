import SwiftUI
import SwiftData
import UserNotifications

private enum Constants {
    enum Layout {
        static let vStackSpacing: CGFloat = 16
        static let zStackHeight: CGFloat = 96
    }
    
    enum Button {
        static let cornerRadius: CGFloat = 8
        static let width: CGFloat = 196
        static let height: CGFloat = 48
    }
    
    enum Dots {
        static let spacing: CGFloat = 16
        static let size: CGFloat = 16
    }
    
    enum CloseButton {
        static let fontSize: CGFloat = 16
    }
    
    enum Search {
        static let fontSize: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let offsetX: CGFloat = 80

        static let offsetY: CGFloat = -320
        static let sortOffsetY: CGFloat = -160
        static let maxTextWidth: CGFloat = 196
    }
}

struct WelcomeView: View {
    let onDismiss: () -> Void
    let modelContext: ModelContext
    @StateObject private var viewModel: WelcomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showNotificationAlert = false
    @State private var notificationPermissionGranted = false
    @State private var showMainView = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    // MARK: - Initialization
    init(modelContext: ModelContext, onDismiss: @escaping () -> Void) {
        self.modelContext = modelContext
        self.onDismiss = onDismiss
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
                            Text(slideTitle.text.localized)
                                .font(slideTitle.font)
                                .foregroundColor(slideTitle.color)
                                .offset(slideTitle.offset)
                                .multilineTextAlignment(.center)
                        }
                        
                        ForEach(slide.slideTexts) { slideText in
                            Text(slideText.text.localized)
                                .font(slideText.font)
                                .foregroundColor(slideText.color)
                                .offset(slideText.offset)
                                .multilineTextAlignment(slideText.alignment)
                        }
                        
                        Spacer()
                        
                        if slide.number == 4 {
                            Text("search_description".localized)
                                .font(.system(size: Constants.Search.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: Constants.Search.maxTextWidth, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Constants.Search.horizontalPadding)
                                .offset(x: Constants.Search.offsetX, y: Constants.Search.offsetY)
                            
                            Text("sort_description".localized)
                                .font(.system(size: Constants.Search.fontSize))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: Constants.Search.maxTextWidth, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, Constants.Search.horizontalPadding)
                                .offset(x: Constants.Search.offsetX, y: Constants.Search.sortOffsetY)
                        }
                        
                        VStack {
                            if index < viewModel.slides.count - 1 {
                                Button("Next".localized) {
                                    withAnimation {
                                        viewModel.nextPage()
                                    }
                                }
                                .frame(width: Constants.Button.width, height: Constants.Button.height)
                                .background(Colors.mainGreen)
                                .foregroundColor(.black)
                                .cornerRadius(Constants.Button.cornerRadius)
                            } else {
                                Button("Get Started!".localized) {
                                    completeWelcome()
                                }
                                .frame(width: Constants.Button.width, height: Constants.Button.height)
                                .background(Colors.mainGreen)
                                .foregroundColor(.white)
                                .cornerRadius(Constants.Button.cornerRadius)
                            }
                            
                            HStack(spacing: Constants.Dots.spacing) {
                                ForEach(viewModel.slides.indices, id: \.self) { i in
                                    Circle()
                                        .fill(i == viewModel.currentPage ? Colors.mainGreen : Color.gray)
                                        .frame(width: Constants.Dots.size, height: Constants.Dots.size)
                                }
                            }
                            .padding(.top, 16)
                        }
                        .padding(.bottom, 16)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: viewModel.currentPage) { newPage, _ in
                let slide = viewModel.slides[newPage]
                if slide.number == 2 {
                    requestNotificationPermission()
                }
            }
            
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
        withAnimation(.easeInOut(duration: 0.5)) {
            isFirstLaunch = false
        }
        dismiss()
        onDismiss()
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
