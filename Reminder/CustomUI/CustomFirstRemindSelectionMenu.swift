import SwiftUI

// MARK: - Constants
private enum Constants {
    static let listRowInsetsTop: CGFloat = 8
    static let listRowInsetsLeading: CGFloat = 16
    static let listRowInsetsBottom: CGFloat = 8
    static let listRowInsetsTrailing: CGFloat = 16

    static let presentationDetentsHeight: CGFloat = 304
    static let presentationCornerRadius: CGFloat = 24

    static let HstackSpacing: CGFloat = 12
    static let ImageFrameWidth: CGFloat = 24
    static let ImageFrameHeight: CGFloat = 24
    static let VstackSpacing: CGFloat = 4
}

// MARK: - CustomFirstRemindSelectionMenuAddEvent
struct CustomFirstRemindSelectionMenuAddEvent: View {

    // MARK: - Bindings & Environment
    @Binding var isPresented: Bool
    @Binding var selectedRemind: FirstRemind
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(FirstRemind.allCases, id: \.self) { remind in
                    RemindOptionRowAddEvent(
                        remind: remind,
                        isSelected: selectedRemind == remind,
                        action: {
                            selectedRemind = remind
                            dismiss()
                        }
                    )
                    .listRowInsets(EdgeInsets(
                        top: Constants.listRowInsetsTop,
                        leading: Constants.listRowInsetsLeading,
                        bottom: Constants.listRowInsetsBottom,
                        trailing: Constants.listRowInsetsTrailing))
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("First Remind".localized)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([
            .height(Constants.presentationDetentsHeight),
            .medium,
            .large
        ])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}

// MARK: - RemindOptionRowAddEvent
struct RemindOptionRowAddEvent: View {

    // MARK: - Properties
    let remind: FirstRemind
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Computed
    var description: String {
        "You will be reminded".localized + " \(remind.displayName)".localized + "."
    }

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Constants.HstackSpacing) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: Constants.ImageFrameWidth, height: Constants.ImageFrameHeight)

                VStack(alignment: .leading, spacing: Constants.VstackSpacing) {
                    Text(remind.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    Text(description.localized)
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
