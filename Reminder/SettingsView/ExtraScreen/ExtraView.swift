import SwiftUI

// MARK: - Constants
private enum ExtraScreenConstants {
    static let spacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let rowCornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 18
    static let iconCircleSize: CGFloat = 40
    static let iconForegroundColor: Color = .gray
    static let titleFontSize: CGFloat = 18
    static let rowBackgroundColor: Color = Color(.systemGray6)
    static let rowShadow: Color = Color.black.opacity(0.1)
    static let rowShadowRadius: CGFloat = 4
}

struct ExtraInfoView: View {
    @StateObject private var viewModel = ExtraViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: ExtraScreenConstants.spacing) {
                TopHeaderView(title: "Extra") {
                    dismiss()
                }

                ScrollView {
                    VStack(spacing: ExtraScreenConstants.spacing) {
                        settingsRow(
                            title: "App Version: \(viewModel.appVersion)",
                            systemImage: "info.circle"
                        )
                        settingsRow(
                            title: "Memory Usage: \(viewModel.memoryUsage)",
                            systemImage: "memorychip"
                        )
                    }
                    .padding(.horizontal, ExtraScreenConstants.horizontalPadding)
                    .padding(.vertical, ExtraScreenConstants.verticalPadding)
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white.ignoresSafeArea())
        }
    }

    private func settingsRow(
        title: String,
        systemImage: String,
        foregroundColor: Color = .black
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: ExtraScreenConstants.iconCircleSize,
                           height: ExtraScreenConstants.iconCircleSize)
                Image(systemName: systemImage)
                    .font(.system(size: ExtraScreenConstants.iconSize, weight: .semibold))
                    .foregroundColor(ExtraScreenConstants.iconForegroundColor)
            }

            Text(title)
                .font(.system(size: ExtraScreenConstants.titleFontSize, weight: .semibold))
                .foregroundColor(foregroundColor)

            Spacer()

           
        }
        .padding()
        .background(ExtraScreenConstants.rowBackgroundColor)
        .cornerRadius(ExtraScreenConstants.rowCornerRadius)
        .shadow(color: ExtraScreenConstants.rowShadow,
                radius: ExtraScreenConstants.rowShadowRadius,
                x: 0, y: 2)
    }
}
