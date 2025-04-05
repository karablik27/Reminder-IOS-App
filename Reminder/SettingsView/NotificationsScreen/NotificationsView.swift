import SwiftUI
import SwiftData

struct NotificationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NotificationsViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: NotificationsViewModel(context: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Верхняя зелёная панель
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    Text("Notifications")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Colors.mainGreen) // Зеленый фон, как в SettingsView
                
                // Основное содержимое
                ScrollView {
                    VStack(spacing: 16) {
                        // Ячейка с переключателем
                        settingsToggleRow(
                            title: "Push Notifications",
                            systemImage: "bell",
                            isOn: $viewModel.settings.isPushEnabled
                        )
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                }
                .background(Colors.background.ignoresSafeArea()) // Светлый фон, как в SettingsView
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Ячейка с переключателем, стилизованная аналогично SettingsView
    private func settingsToggleRow(
        title: String,
        systemImage: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 12) {
            // Иконка в белом круге
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
