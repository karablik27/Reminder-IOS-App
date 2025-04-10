import SwiftUI
import SwiftData

// MARK: - Constants

private enum LocalizationViewConstants {
    static let containerSpacing: CGFloat = 0
    static let rowPadding: CGFloat = 16
    static let rowHeight: CGFloat = 64
    static let rowBackgroundColor: Color = Color(.systemGray6)
    static let cornerRadius: CGFloat = 20
    static let shadowColor: Color = Color.black.opacity(0.1)
    static let shadowRadius: CGFloat = 4
    static let shadowOffsetX: CGFloat = 0
    static let shadowOffsetY: CGFloat = 2
    static let checkmarkCircleSize: CGFloat = 30
    static let checkmarkFontSize: CGFloat = 16
}

struct LocalizationView: View {
    @StateObject private var viewModel: LocalizationViewModel
    @Environment(\.dismiss) private var dismiss

    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: LocalizationViewModel(modelContext: modelContext)
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: LocalizationViewConstants.containerSpacing) {
                TopHeaderView(title: "Language".localized) {
                    dismiss()
                }

                List {
                    ForEach(viewModel.sortedLanguageCodes, id: \.self) { code in
                        Button {
                            viewModel.selectLanguage(code)
                        } label: {
                            HStack {
                                Text(viewModel.availableLanguages[code] ?? code)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                if viewModel.selectedLanguage == code {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(
                                                width: LocalizationViewConstants.checkmarkCircleSize,
                                                height: LocalizationViewConstants.checkmarkCircleSize
                                            )
                                        Image(systemName: "checkmark")
                                            .font(.system(
                                                size: LocalizationViewConstants.checkmarkFontSize,
                                                weight: .semibold
                                            ))
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(LocalizationViewConstants.rowPadding)
                            .frame(height: LocalizationViewConstants.rowHeight)
                            .background(LocalizationViewConstants.rowBackgroundColor)
                            .cornerRadius(LocalizationViewConstants.cornerRadius)
                            .shadow(
                                color: LocalizationViewConstants.shadowColor,
                                radius: LocalizationViewConstants.shadowRadius,
                                x: LocalizationViewConstants.shadowOffsetX,
                                y: LocalizationViewConstants.shadowOffsetY
                            )
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
