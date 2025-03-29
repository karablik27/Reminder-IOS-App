import SwiftUI

struct CustomTypeSelectionMenuAddEvent: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: EventTypeAddEvent
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(EventTypeAddEvent.allCases, id: \.self) { type in
                    TypeOptionRowAddEvent(
                        type: type,
                        isSelected: selectedType == type,
                        action: {
                           selectedType = type
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
                    Text("Type")
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

struct TypeOptionRowAddEvent: View {
    let type: EventTypeAddEvent
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        switch type {
        case .none:
            return "You need to choose your event type."
        case .birthdays:
            return "You will create a reminder about someone's birthday."
        case .holidays:
            return "You will create a reminder about a holiday."
        case .study:
            return "You will create a reminder about your studies (deadlines, exams, and more)."
        case .movies:
            return "You will create a reminder about movies, cartoons, TV shows, and similar media."
        case .other:
            return "You will create a reminder for something that doesn't fit any of the categories above."
        }
    }

    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.rawValue)
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
