import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddEventViewModel
    
    @State private var showCalendarSheet = false
    @State private var showTypeMenu = false
    
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Event title", text: $viewModel.newTitle)
            }
            
            Section(header: Text("Date")) {
                Button(action: {
                    showCalendarSheet = true
                }) {
                    HStack {
                        Text(viewModel.newEventDate.formatted(date: .numeric, time: .omitted))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                    }
                }
            }

            
            Section(header: Text("Event Type")) {
                Button(action: {
                    
                    showTypeMenu = true
                }) {
                    HStack {
                        Text(viewModel.newType.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("Icon")) {
                Text("Selected Icon: \(viewModel.newIcon)")
            }
            
            Section(header: Text("Information")) {
                TextField("Add information", text: $viewModel.newInformation)
            }
            
            Section(header: Text("First Remind")) {
                Picker("First Remind", selection: $viewModel.newFirstRemind) {
                    ForEach(Enums.FirstRemind.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Button("Save Event") {
                viewModel.addEvent()
                dismiss()
            }
            .disabled(viewModel.newTitle.isEmpty)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold))
                }
            }
        }
        .sheet(isPresented: $showCalendarSheet) {
            CustomCalendarView(selectedDate: $viewModel.newEventDate)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
        }
        .sheet(isPresented: $showTypeMenu) {
            TypeSelectionMenu(isPresented: $showTypeMenu, selectedType: $viewModel.newType)
        }


    }
}
