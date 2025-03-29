import SwiftUI

struct CustomFirstRemindSelectionMenuAddEvent: View {
    @Binding var isPresented: Bool
    @Binding var selectedRemind: FirstRemind
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(FirstRemind.allCases, id: \.self) { remind in
                    RemindOptionRowAddEvent(
                        remind: remind,
                        isSelected: selectedRemind == remind,
                        action: {
                            // При выборе пункта
                            selectedRemind = remind
                            dismiss()
                        }
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("First Remind")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([.height(300), .medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(25)
    }
}

struct RemindOptionRowAddEvent: View {
    let remind: FirstRemind
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        "You will be reminded \(remind.rawValue)."
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(remind.rawValue)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}
