import SwiftUI
import SwiftData

struct AddEventView: View {
    @ObservedObject var viewModel: AddEventViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Event title", text: $viewModel.newTitle)
                }
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
                Section(header: Text("Icon")) {
                    Text("Selected Icon: \(viewModel.newIcon)")
                }
                Section(header: Text("Information")) {
                    TextField("Add information", text: $viewModel.newInformation)
                }
                Button("Save Event") {
                    viewModel.addEvent()
                }
                .disabled(viewModel.newTitle.isEmpty)
            }
            .navigationTitle("Add Event")
        }
    }
}
