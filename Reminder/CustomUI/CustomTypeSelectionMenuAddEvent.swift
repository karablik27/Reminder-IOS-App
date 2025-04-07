import SwiftUI

// MARK: - Constants
private enum Constants {
    // List row insets
    static let listRowInsetTop: CGFloat = 8
    static let listRowInsetLeading: CGFloat = 20
    static let listRowInsetBottom: CGFloat = 8
    static let listRowInsetTrailing: CGFloat = 20
    static let listRowInsets = EdgeInsets(top: listRowInsetTop,
                                          leading: listRowInsetLeading,
                                          bottom: listRowInsetBottom,
                                          trailing: listRowInsetTrailing)
    
    // Presentation constants
    static let presentationHeight: CGFloat = 300
    static let presentationCornerRadius: CGFloat = 25
    
    // Layout constants for option rows
    static let hStackSpacing: CGFloat = 12
    static let imageFrameSize: CGFloat = 24
    static let vStackSpacing: CGFloat = 4
}

// MARK: - CustomTypeSelectionMenuAddEvent
struct CustomTypeSelectionMenuAddEvent: View {
    
    // MARK: - Bindings & Environment
    @Binding var isPresented: Bool
    @Binding var selectedType: EventTypeAddEvent
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(EventTypeAddEvent.allCases, id: \.self) { type in
                    TypeOptionRowAddEvent(
                        type: type,
                        isSelected: selectedType == type,
                        action: {
                            selectedType = type
                            dismiss()
                        }
                    )
                    .listRowInsets(Constants.listRowInsets)
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Type".localized)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([.height(Constants.presentationHeight), .medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}

// MARK: - TypeOptionRowAddEvent
struct TypeOptionRowAddEvent: View {
    
    // MARK: - Properties
    let type: EventTypeAddEvent
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Computed Properties
    var description: String {
        switch type {
        case .none:
            return "You need to choose your event type.".localized
        case .birthdays:
            return "You will create a reminder about someone's birthday.".localized
        case .holidays:
            return "You will create a reminder about a holiday.".localized
        case .study:
            return "You will create a reminder about your studies (deadlines, exams, and more).".localized
        case .movies:
            return "You will create a reminder about movies, cartoons, TV shows, and similar media.".localized
        case .anniversary:
            return "You will create a reminder about a special anniversary.".localized
        case .travel:
            return "You will create a reminder about a trip or vacation.".localized
        case .concerts:
            return "You will create a reminder about a concert, festival, or live event.".localized
        case .goals:
            return "You will create a reminder to track your goals or deadlines.".localized
        case .health:
            return "You will create a reminder about health-related things (e.g. appointments).".localized
        case .meetings:
            return "You will create a reminder about a meeting or important appointment.".localized
        case .reminders:
            return "You will create a general reminder for something important.".localized
        case .work:
            return "You will create a reminder about work tasks or projects.".localized
        case .shopping:
            return "You will create a reminder about shopping or sales.".localized
        case .romantic:
            return "You will create a reminder about romantic moments or dates.".localized
        case .firstTime:
            return "You will create a reminder about something happening for the first time.".localized
        case .wishDate:
            return "You will create a reminder for a dream or wish you'd like to remember.".localized
        case .memorable:
            return "You will create a reminder about a memorable or meaningful moment.".localized
        case .other:
            return "You will create a reminder for something that doesn't fit any of the categories above.".localized
        }
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Constants.hStackSpacing) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: Constants.imageFrameSize, height: Constants.imageFrameSize)
                
                VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
                    Text(type.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}
