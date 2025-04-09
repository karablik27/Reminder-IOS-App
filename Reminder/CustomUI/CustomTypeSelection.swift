import SwiftUI

// MARK: - Constants
private enum Constants {
    // List row insets for each cell.
    static let listRowInsetTop: CGFloat = 8
    static let listRowInsetLeading: CGFloat = 20
    static let listRowInsetBottom: CGFloat = 8
    static let listRowInsetTrailing: CGFloat = 20
    static let listRowInsets = EdgeInsets(top: listRowInsetTop, leading: listRowInsetLeading, bottom: listRowInsetBottom, trailing: listRowInsetTrailing)
    static let presentationHeight: CGFloat = 300
    static let presentationCornerRadius: CGFloat = 25
    static let hStackSpacing: CGFloat = 12
    static let imageFrameSize: CGFloat = 24
    static let vStackSpacing: CGFloat = 4
}

// MARK: - TypeSelectionMenu
struct TypeSelectionMenu: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: EventTypeMain
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(EventTypeMain.allCases, id: \.self) { type in
                    TypeOptionRow(
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

// MARK: - TypeOptionRow
struct TypeOptionRow: View {
    let type: EventTypeMain
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Computed Properties
    var description: String {
        switch type {
        case .allEvents:
            return "You will see all events that you have.".localized
        case .birthdays:
            return "You will see all birthday events that you have.".localized
        case .holidays:
            return "You will see all holiday events that you have.".localized
        case .study:
            return "You will see all study-related events that you have.".localized
        case .movies:
            return "You will see all movie, cartoon, and TV show events that you have.".localized
        case .anniversary:
            return "You will see all anniversary events that you have.".localized
        case .travel:
            return "You will see all travel and trip events that you have.".localized
        case .concerts:
            return "You will see all concert or festival events that you have.".localized
        case .goals:
            return "You will see all goal-related or deadline events that you have.".localized
        case .health:
            return "You will see all health-related events like appointments that you have.".localized
        case .meetings:
            return "You will see all meeting or appointment events that you have.".localized
        case .reminders:
            return "You will see all general reminder events that you have.".localized
        case .work:
            return "You will see all work-related events that you have.".localized
        case .shopping:
            return "You will see all shopping or sale events that you have.".localized
        case .romantic:
            return "You will see all romantic events or dates that you have.".localized
        case .firstTime:
            return "You will see all first-time experiences you've saved.".localized
        case .wishDate:
            return "You will see all wish or dream events that you have.".localized
        case .memorable:
            return "You will see all memorable or meaningful events that you have.".localized
        case .other:
            return "You will see all other events that don't fit into a specific category.".localized
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
