import SwiftUI
import SwiftData

// MARK: - Layout & Style Constants
private enum LayoutConstants {
    // Header
    static let headerHorizontalPadding: CGFloat = 16
    static let headerVerticalPadding: CGFloat = 8
    static let headerFontSize: CGFloat = 24
    static let backIconSize: CGFloat = 18
    // Content Spacing
    static let topStackSpacing: CGFloat = 0
    static let sectionSpacing: CGFloat = 16
    static let rowHStackSpacing: CGFloat = 12
    // ScrollView Padding
    static let scrollVerticalPadding: CGFloat = 16
    static let scrollHorizontalPadding: CGFloat = 8
    // Icons
    static let rowIconSize: CGFloat = 40
    static let rowIconFontSize: CGFloat = 18
    static let disclosureIconFontSize: CGFloat = 16
    // Card Styling
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 4
    static let shadowXOffset: CGFloat = 0
    static let shadowYOffset: CGFloat = 2
    static let shadowOpacity: Double = 0.1
}

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showResetConfirmation: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: LayoutConstants.topStackSpacing) {
                // MARK: - Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: LayoutConstants.backIconSize, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("Settings".localized)
                        .font(.system(size: LayoutConstants.headerFontSize, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, LayoutConstants.headerHorizontalPadding)
                .padding(.vertical, LayoutConstants.headerVerticalPadding)
                .background(Colors.mainGreen)

                // MARK: - Content
                ScrollView {
                    VStack(spacing: LayoutConstants.sectionSpacing) {
                        NavigationLink(destination: NotificationsView(modelContext: modelContext)) {
                            settingsRow(title: "Notifications".localized, systemImage: "bell")
                        }
                        NavigationLink(destination: LocalizationView(modelContext: modelContext)) {
                            settingsRow(title: "Language".localized, systemImage: "globe")
                        }
                        NavigationLink(destination: FAQView()) {
                            settingsRow(title: "FAQ".localized, systemImage: "questionmark.circle")
                        }
                        NavigationLink(destination: ExtraInfoView()) {
                            settingsRow(title: "Extra".localized, systemImage: "gearshape.2")
                        }
                        NavigationLink(destination: WelcomeView(modelContext: modelContext, onDismiss: {})) {
                            settingsRow(title: "Show Welcome".localized, systemImage: "sparkles")
                        }
                        Button {
                            showResetConfirmation = true
                        } label: {
                            settingsRow(title: "Factory Reset".localized,
                                        systemImage: "exclamationmark.arrow.circlepath",
                                        foregroundColor: .red)
                        }
                        .buttonStyle(.plain)
                        .confirmationDialog(
                            "Are you sure you want to factory reset?".localized,
                            isPresented: $showResetConfirmation,
                            titleVisibility: .visible
                        ) {
                            Button("Factory Reset".localized, role: .destructive) {
                                viewModel.factoryReset()
                            }
                            Button("Cancel".localized, role: .cancel) { }
                        }
                    }
                    .padding(.vertical, LayoutConstants.scrollVerticalPadding)
                    .padding(.horizontal, LayoutConstants.scrollHorizontalPadding)
                }
                .background(Colors.background.ignoresSafeArea())
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Settings Row
    private func settingsRow(
        title: String,
        systemImage: String,
        foregroundColor: Color = .black
    ) -> some View {
        HStack(spacing: LayoutConstants.rowHStackSpacing) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: LayoutConstants.rowIconSize,
                           height: LayoutConstants.rowIconSize)
                Image(systemName: systemImage)
                    .font(.system(size: LayoutConstants.rowIconFontSize,
                                  weight: .semibold))
                    .foregroundColor(.gray)
            }

            Text(title)
                .font(.headline)
                .foregroundColor(foregroundColor)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: LayoutConstants.disclosureIconFontSize,
                              weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(LayoutConstants.cornerRadius)
        .shadow(color: Color.black.opacity(LayoutConstants.shadowOpacity),
                radius: LayoutConstants.shadowRadius,
                x: LayoutConstants.shadowXOffset,
                y: LayoutConstants.shadowYOffset)
    }
}
