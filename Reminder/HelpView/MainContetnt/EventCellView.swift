import SwiftUI

// MARK: - EventCellView
struct EventCellView: View {
    
    // MARK: - Properties
    let model: EventsModel
    let toggleBookmark: (EventsModel) -> Void
    let timeLeftString: (EventsModel) -> String
    let editDestination: () -> AnyView

    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Left Section (Bookmark + Icon + Text)
            HStack(spacing: ConstantsMain.eventCell.HStackspacing) {
                
                // MARK: Bookmark Button
                Button(action: { toggleBookmark(model) }) {
                    Image(systemName: model.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: ConstantsMain.eventCell.fontSizeIcon))
                        .foregroundColor(model.isBookmarked ? .black : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, ConstantsMain.eventCell.paddingLeading)
                .padding(.trailing, ConstantsMain.eventCell.paddingTrailing)

                // MARK: Icon
                if let iconData = model.iconData, let uiImage = UIImage(data: iconData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: ConstantsMain.eventCell.iconSize,
                               height: ConstantsMain.eventCell.iconSize)
                        .clipShape(Circle())
                } else {
                    Image(model.icon)
                        .resizable()
                        .frame(width: ConstantsMain.eventCell.iconSize,
                               height: ConstantsMain.eventCell.iconSize)
                        .clipShape(Circle())
                }

                // MARK: Event Info
                VStack(alignment: .leading, spacing: ConstantsMain.eventCell.VStackspacing) {
                    Text(model.title)
                        .font(.headline)
                        .lineLimit(ConstantsMain.eventCell.lineLimitText)
                        .truncationMode(.tail)
                        .layoutPriority(ConstantsMain.eventCell.layoutPriority)

                    Text("\(model.dateFormatted) \(model.dayOfWeek)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(ConstantsMain.eventCell.lineLimitDate)
                        .truncationMode(.tail)
                }
            }
            .layoutPriority(ConstantsMain.eventCell.layoutPriority)

            Spacer()

            // MARK: - Right Section (Time Left)
            HStack {
                NavigationLink(destination: editDestination()) {
                    Text(timeLeftString(model))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(ConstantsMain.eventCell.lineLimitDate)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(minWidth: ConstantsMain.eventCell.frameMinHeight, alignment: .trailing)
            .padding(.trailing, ConstantsMain.eventCell.paddingTrailing)
        }

        // MARK: - Cell Background
        .padding(.vertical, ConstantsMain.eventCell.paddingVertical)
        .background(Color.white)
        .cornerRadius(ConstantsMain.eventCell.cornerRadius)
        .shadow(radius: ConstantsMain.eventCell.shadowRadius)
    }
}
