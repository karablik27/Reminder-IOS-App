import SwiftUI
import SwiftData

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showResetConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Верхняя панель с зелёным фоном
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("Settings".localized)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Colors.mainGreen)
                
                // Основное содержимое
                ScrollView {
                    VStack(spacing: 16) {
                        // Ячейка с переходом к уведомлениям
                        NavigationLink(destination: NotificationsView(modelContext: modelContext)) {
                            settingsRow(
                                title: "Notifications".localized,
                                systemImage: "bell"
                            )
                        }
                        
                        // Ячейка с выбором языка
                        NavigationLink(destination: LocalizationView(modelContext: modelContext)) {
                            settingsRow(
                                title: "Language".localized,
                                systemImage: "globe"
                            )
                        }

                        // Новая ячейка FAQ с переходом на экран FAQView
                        NavigationLink(destination: FAQView()) {
                            settingsRow(
                                title: "FAQ".localized,
                                systemImage: "questionmark.circle"
                            )
                        }
                        
                        NavigationLink(destination: ExtraInfoView()) {
                            settingsRow(
                                title: "Extra".localized,
                                systemImage: "gearshape.2"
                            )
                        }
                        
                        NavigationLink(destination: WelcomeView(modelContext: modelContext, onDismiss: {})) {
                            settingsRow(
                                title: "Show Welcome".localized,
                                systemImage: "sparkles"
                            )
                        }
                        
                        // Ячейка "Factory Reset" с подтверждением
                        Button {
                            showResetConfirmation = true
                        } label: {
                            settingsRow(
                                title: "Factory Reset ".localized,
                                systemImage: "exclamationmark.arrow.circlepath",
                                foregroundColor: .red
                            )
                        }
                        .buttonStyle(.plain)
                        .confirmationDialog("Are you sure you want to factory reset?".localized, isPresented: $showResetConfirmation, titleVisibility: .visible) {
                            Button("Factory Reset ".localized, role: .destructive) {
                                viewModel.factoryReset()
                            }
                            Button("Cancel ".localized, role: .cancel) { }
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
                .background(Colors.background.ignoresSafeArea())
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
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
                    .frame(width: 40, height: 40)
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(foregroundColor)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
