import SwiftUI
import SwiftData

struct WelcomeScreenData {
    // MARK: - Constants
    private enum Constants {
        
        enum Slide1 {
            static let titleOffsetX: CGFloat = 0
            static let titleOffsetY: CGFloat = 35
            static let textOffsetX: CGFloat = 0
            static let textOffsetY: CGFloat = 25
            static let titleFont = Font.system(size: 35, weight: .bold)
            static let textFont = Font.system(size: 17)
        }
        
        enum Slide2 {
            static let icon1OffsetX: CGFloat = -130
            static let icon1OffsetY: CGFloat = 110
            static let icon2OffsetX: CGFloat = -60
            static let icon2OffsetY: CGFloat = 200
            static let iconSizeWidth: CGFloat = 35
            static let iconSizeHeight: CGFloat = 35
            
            static let titleOffsetX: CGFloat = 0
            static let titleOffsetY: CGFloat = -85
            
            static let text1OffsetX: CGFloat = 0
            static let text1OffsetY: CGFloat = -75
            
            static let text2OffsetX: CGFloat = 0
            static let text2OffsetY: CGFloat = -20
            
            static let text3OffsetX: CGFloat = 40
            static let text3OffsetY: CGFloat = 30
            
            static let titleFont = Font.system(size: 35, weight: .bold)
            static let textFont = Font.system(size: 17)
            static let bodyFont = Font.body
        }
        
        enum Slide3 {
            static let titleOffsetX: CGFloat = 0
            static let titleOffsetY: CGFloat = 35
            static let textOffsetX: CGFloat = 0
            static let textOffsetY: CGFloat = 25
            static let titleFont = Font.system(size: 35, weight: .bold)
            static let textFont = Font.system(size: 17)
        }
        
        enum Slide4 {
            static let icon1OffsetX: CGFloat = -100
            static let icon1OffsetY: CGFloat = 150
            static let icon2OffsetX: CGFloat = -100
            static let icon2OffsetY: CGFloat = 400
            static let iconSizeWidth: CGFloat = 50
            static let iconSizeHeight: CGFloat = 50
            
            static let titleOffsetX: CGFloat = 0
            static let titleOffsetY: CGFloat = -85
            
            static let text1OffsetY: CGFloat = 56
            static let text2OffsetY: CGFloat = 280
            
            static let titleFont = Font.system(size: 35, weight: .bold)
            static let textFont = Font.system(size: 17)
        }
    }

    static let slides = [
        // Slide 1: Welcome
        WelcomeSlide(
            number: 1,
            slideTitles: [
                SlideTitle(
                    text: NSLocalizedString("Reminder", comment: "Title for slide 1, e.g. 'Reminder'"),
                    offset: CGSize(width: Constants.Slide1.titleOffsetX, height: Constants.Slide1.titleOffsetY),
                    font: Constants.Slide1.titleFont,
                    color: .black
                )
            ],
            slideTexts: [
                SlideText(
                    text: NSLocalizedString("welcome_text", comment: "Welcome message explaining the app's purpose"),
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
                    text: NSLocalizedString("create_reminder", comment: "Title for slide 2, e.g. 'Create a new reminder'"),
                    offset: CGSize(width: Constants.Slide2.titleOffsetX, height: Constants.Slide2.titleOffsetY),
                    font: Constants.Slide2.titleFont,
                    color: .black
                )
            ],
            slideTexts: [
                SlideText(
                    text: NSLocalizedString("create_reminder_step1", comment: "Step 1: Instruction for creating a reminder"),
                    offset: CGSize(width: Constants.Slide2.text1OffsetX, height: Constants.Slide2.text1OffsetY),
                    font: Constants.Slide2.textFont,
                    color: .primary,
                    alignment: .center
                ),
                SlideText(
                    text: NSLocalizedString("create_reminder_step2", comment: "Step 2: Additional instructions for creating a reminder"),
                    offset: CGSize(width: Constants.Slide2.text2OffsetX, height: Constants.Slide2.text2OffsetY),
                    font: Constants.Slide2.bodyFont,
                    color: .primary,
                    alignment: .center
                ),
                SlideText(
                    text: NSLocalizedString("create_reminder_step3", comment: "Step 3: Final step instruction for creating a reminder"),
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
                    text: NSLocalizedString("notifications_title", comment: "Title for slide 3, e.g. 'Notifications'"),
                    offset: CGSize(width: Constants.Slide3.titleOffsetX, height: Constants.Slide3.titleOffsetY),
                    font: Constants.Slide3.titleFont,
                    color: .black
                )
            ],
            slideTexts: [
                SlideText(
                    text: NSLocalizedString("notifications_text", comment: "Instruction to allow notifications"),
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
                    text: NSLocalizedString("search_sort_title", comment: "Title for slide 4, e.g. 'Search and Sort events'"),
                    offset: CGSize(width: Constants.Slide4.titleOffsetX, height: Constants.Slide4.titleOffsetY),
                    font: Constants.Slide4.titleFont,
                    color: .black
                )
            ],
            slideTexts: [
                SlideText(
                    text: NSLocalizedString("search_symbol", comment: "Label for the search symbol"),
                    offset: CGSize(width: Constants.Slide4.icon1OffsetX, height: Constants.Slide4.text1OffsetY),
                    font: Constants.Slide4.textFont,
                    color: .primary,
                    alignment: .center
                ),
                SlideText(
                    text: NSLocalizedString("sort_symbol", comment: "Label for the sort symbol"),
                    offset: CGSize(width: Constants.Slide4.icon2OffsetX, height: Constants.Slide4.text2OffsetY),
                    font: Constants.Slide4.textFont,
                    color: .primary,
                    alignment: .center
                )
            ]
        )
    ]
}
