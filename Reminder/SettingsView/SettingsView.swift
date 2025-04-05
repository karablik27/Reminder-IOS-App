import SwiftUI
import SwiftData

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Шапка (верхняя панель)
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("Settings")
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
                        
                        // Ячейка с переходом (NavigationLink)
                        NavigationLink(destination: NotificationsView(modelContext: modelContext)) {
                            settingsRow(
                                title: "Notifications",
                                systemImage: "bell"
                            )
                        }
                        
                        // Ячейка с действием для языка
                        Button {
                            print("Open Language screen")
                        } label: {
                            settingsRow(
                                title: "Language",
                                systemImage: "globe"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        // Ячейка с переключателем Dark Mode
                        settingsToggleRow(
                            title: "Dark Mode",
                            systemImage: "moon.stars.fill",
                            isOn: $viewModel.isDarkMode
                        )
                        
                        // Ячейка "Rate in App Store"
                        Button {
                            viewModel.rateInAppStore()
                        } label: {
                            settingsRow(
                                title: "Rate in App Store",
                                systemImage: "star"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        // Ячейка "Factory Reset"
                        Button {
                            viewModel.factoryReset()
                        } label: {
                            settingsRow(
                                title: "Factory Reset",
                                systemImage: "exclamationmark.arrow.circlepath",
                                foregroundColor: .red
                            )
                        }
                        .buttonStyle(.plain)
                        
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
    
    // Универсальная ячейка без подзаголовка: иконка в белом круге, заголовок и стрелка
    private func settingsRow(
        title: String,
        systemImage: String,
        foregroundColor: Color = .black
    ) -> some View {
        HStack(spacing: 12) {
            // Кружок с иконкой
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            // Заголовок
            Text(title)
                .font(.headline)
                .foregroundColor(foregroundColor)
            
            Spacer()
            
            // Стрелка вправо
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Ячейка с переключателем без подзаголовка
    private func settingsToggleRow(
        title: String,
        systemImage: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 12) {
            // Кружок с иконкой
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            // Заголовок
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            // Переключатель
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Colors.mainGreen))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
