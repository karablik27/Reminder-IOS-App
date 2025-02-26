import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: AddEventViewModel
    
    var body: some View {
        Form {
            // Название события
            Section(header: Text("Name")) {
                TextField("Event title", text: $viewModel.newTitle)
            }
            
            // Тип события
            Section(header: Text("Event Type")) {
                Picker("Event Type", selection: $viewModel.newType) {
                    ForEach(Enums.EventType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(of: viewModel.newType) { _ in
                    viewModel.updateIcon()
                }
            }
            
            // Иконка события
            Section(header: Text("Icon")) {
                Text("Selected Icon: \(viewModel.newIcon)")
            }
            
            // Информация о событии
            Section(header: Text("Information")) {
                TextField("Add information", text: $viewModel.newInformation)
            }
            
            // Кнопка сохранения события
            Button("Save Event") {
                viewModel.addEvent()  // Сохранение события
            }
            .disabled(viewModel.newTitle.isEmpty) // Отключить кнопку, если название пустое
        }
        .navigationTitle("Add Event")
    }
}
