import SwiftUI

struct TypeSelectionMenu: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: EventTypeMain
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(EventTypeMain.allCases, id: \.self) { type in
                    TypeOptionRow(
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
                    Text("Type".localized)
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

struct TypeOptionRow: View {
    let type: EventTypeMain
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        switch type {
        case .allEvents:
            return "You will see all events, that you have.".localized
        case .birthdays:
            return "You will see all birthday events, that you have.".localized
        case .holidays:
            return "You will see all holidays events, that you have.".localized
        case .study:
            return "You will see all study events, that you have.".localized
        case .movies:
            return "You will see all movie events, that you have.".localized
        case .other:
            return "You will see all other events, that you have.".localized
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.displayName)
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
