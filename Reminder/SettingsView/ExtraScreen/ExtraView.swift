import SwiftUI

// MARK: - Constants

private enum ExtraScreenConstants {
    static let spacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16

    static let rowContentSpacing: CGFloat = 12
    static let rowPadding: CGFloat = 16
    static let rowCornerRadius: CGFloat = 20
    static let rowBackgroundColor: Color = Color(.systemGray6)
    static let rowShadowColor: Color = Color.black.opacity(0.1)
    static let rowShadowRadius: CGFloat = 4
    static let rowShadowOffsetX: CGFloat = 0
    static let rowShadowOffsetY: CGFloat = 2

    static let iconCircleSize: CGFloat = 40
    static let iconSize: CGFloat = 18
    static let iconForegroundColor: Color = .gray

    static let titleFontSize: CGFloat = 18
    static let valueFontSize: CGFloat = 18

    static let backgroundColor: Color = .white
}

// MARK: - View

struct ExtraInfoView: View {
    @StateObject private var viewModel = ExtraViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: ExtraScreenConstants.spacing) {
                TopHeaderView(title: "Extra".localized) {
                    dismiss()
                }

                ScrollView {
                    VStack(spacing: ExtraScreenConstants.spacing) {
                        settingsRow(
                            label: "App Version:".localized,
                            value: viewModel.appVersion,
                            systemImage: "info.circle"
                        )
                        settingsRow(
                            label: "Memory Usage:".localized,
                            value: viewModel.memoryUsage,
                            systemImage: "memorychip"
                        )
                    }
                    .padding(.horizontal, ExtraScreenConstants.horizontalPadding)
                    .padding(.vertical, ExtraScreenConstants.verticalPadding)
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(ExtraScreenConstants.backgroundColor.ignoresSafeArea())
        }
    }

    private func settingsRow(
        label: String,
        value: String,
        systemImage: String,
        foregroundColor: Color = .black
    ) -> some View {
        HStack(spacing: ExtraScreenConstants.rowContentSpacing) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(
                        width: ExtraScreenConstants.iconCircleSize,
                        height: ExtraScreenConstants.iconCircleSize
                    )
                Image(systemName: systemImage)
                    .font(.system(size: ExtraScreenConstants.iconSize, weight: .semibold))
                    .foregroundColor(ExtraScreenConstants.iconForegroundColor)
            }

            Text(label)
                .font(.system(size: ExtraScreenConstants.titleFontSize, weight: .semibold))
                .foregroundColor(foregroundColor)

            Spacer()

            Text(value)
                .font(.system(size: ExtraScreenConstants.valueFontSize, weight: .regular))
                .foregroundColor(foregroundColor)
        }
        .padding(ExtraScreenConstants.rowPadding)
        .background(ExtraScreenConstants.rowBackgroundColor)
        .cornerRadius(ExtraScreenConstants.rowCornerRadius)
        .shadow(
            color: ExtraScreenConstants.rowShadowColor,
            radius: ExtraScreenConstants.rowShadowRadius,
            x: ExtraScreenConstants.rowShadowOffsetX,
            y: ExtraScreenConstants.rowShadowOffsetY
        )
    }
}
