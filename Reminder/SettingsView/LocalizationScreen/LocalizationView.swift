import SwiftUI
import SwiftData

struct LocalizationView: View {
    @StateObject private var viewModel: LocalizationViewModel
    @Environment(\.dismiss) private var dismiss

    // Принимаем modelContext из родительского экрана
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: LocalizationViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("Language".localized)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Colors.mainGreen)
                
                List {
                    ForEach(viewModel.sortedLanguageCodes, id: \.self) { languageCode in
                        Button {
                            viewModel.selectLanguage(languageCode)
                        } label: {
                            HStack {
                                Text(viewModel.availableLanguages[languageCode] ?? languageCode)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                if viewModel.selectedLanguage == languageCode {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 30, height: 30)
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color.green)
                                    }
                                }
                            }
                            .padding()
                            .frame(height: 64)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
