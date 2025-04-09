import SwiftUI

struct IconAndTitleSection: View {
    let userSelectedImage: UIImage?
    let eventType: EventTypeAddEvent
    let defaultIcon: (EventTypeAddEvent) -> String
    let displayedTitle: String
    let onIconTap: () -> Void

    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: CommonConstants.sectionSpacing) {
                Button(action: onIconTap) {
                    ZStack {
                        Circle()
                            .stroke(Color.black, lineWidth: CommonConstants.iconStrokeWidth)
                            .frame(width: CommonConstants.iconSize, height: CommonConstants.iconSize)
                        if let userImage = userSelectedImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: CommonConstants.iconSize, height: CommonConstants.iconSize)
                                .clipShape(Circle())
                        } else if eventType != .none {
                            Image(defaultIcon(eventType))
                                .resizable()
                                .scaledToFill()
                                .frame(width: CommonConstants.iconSize, height: CommonConstants.iconSize)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: CommonConstants.defaultCameraIconSize, height: CommonConstants.defaultCameraIconSize)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Text(displayedTitle.localized)
                    .font(.system(size: CommonConstants.titleFontSize, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, CommonConstants.topPadding)
        .padding(.horizontal, CommonConstants.horizontalPadding)
    }
}
