import SwiftUI
import SwiftData

// MARK: - Constants
private enum Constants {
    static let vStackSpacing: CGFloat = 0
    static let rowSpacing: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 8
    static let rowPadding: CGFloat = 16
    static let iconSize: CGFloat = 40
    static let iconFontSize: CGFloat = 18
    static let cornerRadius: CGFloat = 20
    static let shadowOpacity: Double = 0.1
    static let shadowRadius: CGFloat = 4
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 2
}

// MARK: - NotificationsView
struct NotificationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NotificationsViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: NotificationsViewModel(context: modelContext))
    }
    
    private var pushBinding: Binding<Bool> {
        Binding(
            get: { viewModel.settings.isPushEnabled },
            set: { newValue in viewModel.togglePush(newValue, context: modelContext) }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Constants.vStackSpacing) {
                TopHeaderView(title: "Notifications".localized) {
                    dismiss()
                }

                ScrollView {
                    VStack(spacing: Constants.rowSpacing) {
                        settingsToggleRow(
                            title: "Push Notifications".localized,
                            systemImage: "bell",
                            isOn: pushBinding
                        )
                    }
                    .padding(.vertical, Constants.verticalPadding)
                    .padding(.horizontal, Constants.horizontalPadding)
                }
                .background(Colors.background.ignoresSafeArea())
            }
        }
    }
    
    // MARK: - settingsToggleRow
    private func settingsToggleRow(
        title: String,
        systemImage: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: Constants.rowSpacing) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
                Image(systemName: systemImage)
                    .font(.system(size: Constants.iconFontSize, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.green))
        }
        .padding(Constants.rowPadding)
        .background(Color(.systemGray6))
        .cornerRadius(Constants.cornerRadius)
        .shadow(color: Color.black.opacity(Constants.shadowOpacity), radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
    }
}
