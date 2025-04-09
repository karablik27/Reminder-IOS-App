import SwiftUI
import SwiftData
import UserNotifications

// MARK: - Constants
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
        static let offsetX: CGFloat = 104
        static let offsetY: CGFloat = -328
        static let sortOffsetY: CGFloat = -196
        static let maxTextWidth: CGFloat = 192
    }
    
    enum Padding {
        static let bottom: CGFloat = 16
        static let dotsTop: CGFloat = 16
    }
    
    enum Image {
        static let offsetYTrue: CGFloat = -64
        static let offsetYFalse: CGFloat = 0
    }
    
    enum slideText {
        static let offsetXTrue: CGFloat = 120
        static let offsetXFalse: CGFloat = -80
        static let offsetYTrue: CGFloat = 40
    }
}

// MARK: - WelcomeView
struct WelcomeView: View {
    let onDismiss: () -> Void
    let modelContext: ModelContext
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @StateObject private var viewModel: WelcomeViewModel
    
    init(modelContext: ModelContext, onDismiss: @escaping () -> Void) {
        self.modelContext = modelContext
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: WelcomeViewModel(modelContext: modelContext))
    }

    var body: some View {
        if viewModel.showMainView {
            EventsView(modelContext: modelContext)
        } else {
            welcomeContent
        }
    }

    // MARK: - Subviews
    private var welcomeContent: some View {
        ZStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.slides.count, id: \.self) { index in
                    WelcomeSlideView(
                        slide: viewModel.slides[index],
                        index: index,
                        totalSlides: viewModel.slides.count,
                        currentPage: viewModel.currentPage,
                        onNext: {
                            withAnimation {
                                viewModel.nextPage()
                            }
                        },
                        onComplete: {
                            viewModel.completeWelcome({ dismiss() }, isFirstLaunch: $isFirstLaunch)
                            onDismiss()
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: viewModel.currentPage) { newPage, _ in
                if viewModel.slides[newPage].number == 2 {
                    viewModel.requestNotificationPermission()
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.completeWelcome({ dismiss() }, isFirstLaunch: $isFirstLaunch)
                        onDismiss()
                    } label: {
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(.black)
                            .font(.system(size: Constants.CloseButton.fontSize))
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - WelcomeSlideView
struct WelcomeSlideView: View {
    let slide: WelcomeSlide
    let index: Int
    let totalSlides: Int
    let currentPage: Int
    let onNext: () -> Void
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: Constants.Layout.vStackSpacing) {
            if !slide.icons.isEmpty {
                ZStack {
                    ForEach(slide.icons) { icon in
                        Image(systemName: icon.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: icon.size.width, height: icon.size.height)
                            .offset(
                                x: icon.offset.width,
                                y: icon.offset.height + ((slide.number == 2 && Localizer.selectedLanguage == "en") ? Constants.Image.offsetYTrue : Constants.Image.offsetYFalse)
                            )
                    }
                }
                .frame(height: Constants.Layout.zStackHeight)
            }

            // Title texts
            ForEach(slide.slideTitles) { slideTitle in
                Text(slideTitle.text.localized)
                    .font(slideTitle.font)
                    .foregroundColor(slideTitle.color)
                    .offset(slideTitle.offset)
                    .multilineTextAlignment(.center)
            }

            // Body texts
            ForEach(slide.slideTexts) { slideText in
                if slide.number == 4 {
                    Text(slideText.text.localized)
                        .font(slideText.font)
                        .foregroundColor(slideText.color)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .frame(maxWidth: Constants.Search.maxTextWidth, alignment: .leading)
                        .padding(.horizontal, Constants.Search.horizontalPadding)
                        .offset(
                            x: (slideText.text.contains("Search: Allows you to find reminders using keywords in the title, description, or other attributes.") ||
                                slideText.text.contains("Sort: Helps you organize your reminders by date, name, or other parameters.") ||
                                slideText.text.contains("Сортировка: помогает организовать напоминания по дате, названию или другим параметрам.") ||
                                slideText.text.contains("Поиск: позволяет находить напоминания по ключевым словам в названии, описании или других атрибутах.")) ? Constants.slideText.offsetXTrue : Constants.slideText.offsetXFalse,
                            y: Localizer.selectedLanguage == "ru" ? slideText.offset.height - Constants.slideText.offsetYTrue : slideText.offset.height
                        )
                        .multilineTextAlignment(.leading)
                } else {
                    Text(slideText.text.localized)
                        .font(slideText.font)
                        .foregroundColor(slideText.color)
                        .offset(slideText.offset)
                        .multilineTextAlignment(slideText.alignment)
                }
            }


            
            Spacer()

            // Navigation buttons and dots
            VStack {
                if index < totalSlides - 1 {
                    Button("Next".localized) {
                        onNext()
                    }
                    .frame(width: Constants.Button.width, height: Constants.Button.height)
                    .background(Colors.mainGreen)
                    .foregroundColor(.black)
                    .cornerRadius(Constants.Button.cornerRadius)
                } else {
                    Button("Get Started!".localized) {
                        onComplete()
                    }
                    .frame(width: Constants.Button.width, height: Constants.Button.height)
                    .background(Colors.mainGreen)
                    .foregroundColor(.black)
                    .cornerRadius(Constants.Button.cornerRadius)
                }

                HStack(spacing: Constants.Dots.spacing) {
                    ForEach(0..<totalSlides, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage ? Colors.mainGreen : Color.gray)
                            .frame(width: Constants.Dots.size, height: Constants.Dots.size)
                    }
                }
                .padding(.top, Constants.Padding.dotsTop)
            }
            .padding(.bottom, Constants.Padding.bottom)
        }
    }
}
