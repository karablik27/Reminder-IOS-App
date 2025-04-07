import SwiftUI

// MARK: - Constants
private enum Constants {
    static let listRowInsetsTop: CGFloat = 8
    static let listRowInsetsBottom: CGFloat = 8
    static let listRowInsetsLeading: CGFloat = 20
    static let listRowInsetsTrailing: CGFloat = 20

    static let presentationHeight: CGFloat = 300
    static let presentationCornerRadius: CGFloat = 25

    static let hStackSpacing: CGFloat = 12
    static let imageSize: CGFloat = 24
    static let vStackSpacing: CGFloat = 4
}

// MARK: - CustomHowOftenSelectionMenuAddEvent
struct CustomHowOftenSelectionMenuAddEvent: View {

    // MARK: - Bindings & Environment
    @Binding var isPresented: Bool
    @Binding var selectedHowOften: ReminderFrequency
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(ReminderFrequency.allCases, id: \.self) { freq in
                    HowOftenOptionRowAddEvent(
                        freq: freq,
                        isSelected: selectedHowOften == freq,
                        action: {
                            selectedHowOften = freq
                            dismiss()
                        }
                    )
                    .listRowInsets(EdgeInsets(
                        top: Constants.listRowInsetsTop,
                        leading: Constants.listRowInsetsLeading,
                        bottom: Constants.listRowInsetsBottom,
                        trailing: Constants.listRowInsetsTrailing
                    ))
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Reminder Frequency".localized)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([
            .height(Constants.presentationHeight),
            .medium,
            .large
        ])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(Constants.presentationCornerRadius)
    }
}

// MARK: - HowOftenOptionRowAddEvent
struct HowOftenOptionRowAddEvent: View {

    // MARK: - Properties
    let freq: ReminderFrequency
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Computed
    var description: String {
        switch freq {
        case .everyFiveSeconds:
            return "Remind every 1 minute.".localized
        case .everyHour:
            return "Remind every 1 hour.".localized
        case .everyDay:
            return "Remind every 1 day.".localized
        case .everyWeek:
            return "Remind every 1 week.".localized
        }
    }

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: Constants.hStackSpacing) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: Constants.imageSize, height: Constants.imageSize)

                VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
                    Text(freq.displayName)
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
