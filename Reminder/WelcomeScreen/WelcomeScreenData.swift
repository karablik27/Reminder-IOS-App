import SwiftUI
import SwiftData

// MARK: - Constants
private enum Constants {
    
    enum Slide1 {
        static let titleOffsetX: CGFloat = 0
        static let titleOffsetY: CGFloat = 32
        static let textOffsetX: CGFloat = 0
        static let textOffsetY: CGFloat = 24
        static let titleFont = Font.system(size: 32, weight: .bold)
        static let textFont = Font.system(size: 16)
    }
    
    enum Slide2 {
        static let icon1OffsetX: CGFloat = -120
        static let icon1OffsetY: CGFloat = 160
        static let icon2OffsetX: CGFloat = -40
        static let icon2OffsetY: CGFloat = 272
        static let iconSizeWidth: CGFloat = 32
        static let iconSizeHeight: CGFloat = 32
        
        static let titleOffsetX: CGFloat = 0
        static let titleOffsetY: CGFloat = -88
        
        static let text1OffsetX: CGFloat = 0
        static let text1OffsetY: CGFloat = -72
        
        static let text2OffsetX: CGFloat = 0
        static let text2OffsetY: CGFloat = -24
        
        static let text3OffsetX: CGFloat = 40
        static let text3OffsetY: CGFloat = 32
        
        static let titleFont = Font.system(size: 32, weight: .bold)
        static let textFont = Font.system(size: 17)
        static let bodyFont = Font.body
    }
    
    enum Slide3 {
        static let titleOffsetX: CGFloat = 0
        static let titleOffsetY: CGFloat = 32
        static let textOffsetX: CGFloat = 0
        static let textOffsetY: CGFloat = 24
        static let titleFont = Font.system(size: 32, weight: .bold)
        static let textFont = Font.system(size: 16)
    }
    
    enum Slide4 {
        static let icon1OffsetX: CGFloat = -120
        static let icon1OffsetY: CGFloat = 156
        static let icon2OffsetX: CGFloat = -120
        static let icon2OffsetY: CGFloat = 400
        static let iconSizeWidth: CGFloat = 48
        static let iconSizeHeight: CGFloat = 48
        
        static let titleOffsetX: CGFloat = 0
        static let titleOffsetY: CGFloat = -88
        
        static let text1OffsetY: CGFloat = 56
        static let text2OffsetY: CGFloat = 272
        
        static let offsetXSearch: CGFloat = 200
        static let offsetYSearch: CGFloat = -72
        static let offsetXSort: CGFloat = 196
        static let offsetYSort: CGFloat = 64
        
        static let titleFont = Font.system(size: 32, weight: .bold)
        static let textFont = Font.system(size: 16)
        
    
        
        
    }
}

// MARK: - Welcome Screen Data
struct WelcomeScreenData {
    static var slides: [WelcomeSlide] {
        return [
            // Slide 1: Welcome
            WelcomeSlide(
                number: 1,
                slideTitles: [
                    SlideTitle(
                        text: "Reminder",
                        offset: CGSize(width: Constants.Slide1.titleOffsetX, height: Constants.Slide1.titleOffsetY),
                        font: Constants.Slide1.titleFont,
                        color: .black
                    )
                ],
                slideTexts: [
                    SlideText(
                        text: "Welcome to a convenient application that helps you remember the main thing.".localized,
                        offset: CGSize(width: Constants.Slide1.textOffsetX, height: Constants.Slide1.textOffsetY),
                        font: Constants.Slide1.textFont,
                        color: .primary,
                        alignment: .center
                    )
                ]
            ),
            // Slide 2: Create new reminder
            WelcomeSlide(
                number: 2,
                icons: [
                    SlideIcon(
                        iconName: "arrow.down",
                        offset: CGSize(width: Constants.Slide2.icon1OffsetX, height: Constants.Slide2.icon1OffsetY),
                        size: CGSize(width: Constants.Slide2.iconSizeWidth, height: Constants.Slide2.iconSizeHeight)
                    ),
                    SlideIcon(
                        iconName: "arrow.down",
                        offset: CGSize(width: Constants.Slide2.icon2OffsetX, height: Constants.Slide2.icon2OffsetY),
                        size: CGSize(width: Constants.Slide2.iconSizeWidth, height: Constants.Slide2.iconSizeHeight)
                    )
                ],
                slideTitles: [
                    SlideTitle(
                        text: "Create a new reminder".localized,
                        offset: CGSize(width: Constants.Slide2.titleOffsetX, height: Constants.Slide2.titleOffsetY),
                        font: Constants.Slide2.titleFont,
                        color: .black
                    )
                ],
                slideTexts: [
                    SlideText(
                        text: "1. Tap the '+' button to create a new reminder.".localized,
                        offset: CGSize(width: Constants.Slide2.text1OffsetX, height: Constants.Slide2.text1OffsetY),
                        font: Constants.Slide2.textFont,
                        color: .primary,
                        alignment: .center
                    ),
                    SlideText(
                        text: "2. Then choose a title, date, and more.".localized,
                        offset: CGSize(width: Constants.Slide2.text2OffsetX, height: Constants.Slide2.text2OffsetY),
                        font: Constants.Slide2.bodyFont,
                        color: .primary,
                        alignment: .center
                    ),
                    SlideText(
                        text: "3. Save and wait for a reminder!".localized,
                        offset: CGSize(width: Constants.Slide2.text3OffsetX, height: Constants.Slide2.text3OffsetY),
                        font: Constants.Slide2.bodyFont,
                        color: .primary,
                        alignment: .center
                    )
                ]
            ),
            // Slide 3: Notifications
            WelcomeSlide(
                number: 3,
                slideTitles: [
                    SlideTitle(
                        text: "Notifications".localized,
                        offset: CGSize(width: Constants.Slide3.titleOffsetX, height: Constants.Slide3.titleOffsetY),
                        font: Constants.Slide3.titleFont,
                        color: .black
                    )
                ],
                slideTexts: [
                    SlideText(
                        text: "Click allow to receive notifications about your events and more, or configure later in settings.".localized,
                        offset: CGSize(width: Constants.Slide3.textOffsetX, height: Constants.Slide3.textOffsetY),
                        font: Constants.Slide3.textFont,
                        color: .primary,
                        alignment: .center
                    )
                ]
            ),
            // Slide 4: Search and Sort
            WelcomeSlide(
                number: 4,
                icons: [
                    SlideIcon(
                        iconName: "magnifyingglass",
                        offset: CGSize(width: Constants.Slide4.icon1OffsetX, height: Constants.Slide4.icon1OffsetY),
                        size: CGSize(width: Constants.Slide4.iconSizeWidth, height: Constants.Slide4.iconSizeHeight)
                    ),
                    SlideIcon(
                        iconName: "arrow.up.arrow.down",
                        offset: CGSize(width: Constants.Slide4.icon2OffsetX, height: Constants.Slide4.icon2OffsetY),
                        size: CGSize(width: Constants.Slide4.iconSizeWidth, height: Constants.Slide4.iconSizeHeight)
                    )
                ],
                slideTitles: [
                    SlideTitle(
                        text: "Search and Sort events".localized,
                        offset: CGSize(width: Constants.Slide4.titleOffsetX, height: Constants.Slide4.titleOffsetY),
                        font: Constants.Slide4.titleFont,
                        color: .black
                    )
                ],
                slideTexts: [
                    SlideText(
                        text: "Search symbol".localized,
                        offset: CGSize(width: Constants.Slide4.icon1OffsetX, height: Constants.Slide4.text1OffsetY),
                        font: Constants.Slide4.textFont,
                        color: .primary,
                        alignment: .center
                    ),
                    SlideText(
                        text: "Sort symbol".localized,
                        offset: CGSize(width: Constants.Slide4.icon2OffsetX, height: Constants.Slide4.text2OffsetY),
                        font: Constants.Slide4.textFont,
                        color: .primary,
                        alignment: .center
                    ),
                    SlideText(
                        text: "Search: Allows you to find reminders using keywords in the title, description, or other attributes.".localized,
                        offset: CGSize(width: Constants.Slide4.offsetXSearch, height: Constants.Slide4.offsetYSearch),
                        font: Constants.Slide4.textFont,
                        color: .primary,
                        alignment: .leading
                    ),
                    SlideText(
                        text: "Sort: Helps you organize your reminders by date, name, or other parameters.".localized,
                        offset: CGSize(width: Constants.Slide4.offsetXSort, height: Constants.Slide4.offsetYSort),
                        font: Constants.Slide4.textFont,
                        color: .primary,
                        alignment: .leading
                    )
                ]
            )
        ]
    }
}

