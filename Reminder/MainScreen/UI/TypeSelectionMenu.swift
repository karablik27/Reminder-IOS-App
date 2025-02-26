import SwiftUI

struct TypeSelectionMenu: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: Enums.EventType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Enums.EventType.allCases, id: \.self) { type in
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

struct TypeOptionRow: View {
    let type: Enums.EventType
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        switch type {
        case .allEvents:
            return "You will see all events, that you have."
        case .birthdays:
            return "You will see all birthday events, that you have."
        case .holidays:
            return "You will see all holidays events, that you have."
        case .study:
            return "You will see all study events, that you have."
        case .movies:
            return "You will see all movie events, that you have."
        case .other:
            return "You will see all other events, that you have."
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



struct SortOptionRow: View {
    let option: MainViewModel.SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        switch option {
        case .byDate:
            return "You will see events sorted by date."
        case .byName:
            return "You will see events sorted by name."
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.rawValue)
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

struct SortSelectionMenu: View {
    @Binding var isPresented: Bool
    @Binding var selectedSort: MainViewModel.SortOption
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(MainViewModel.SortOption.allCases, id: \.self) { option in
                    SortOptionRow(
                        option: option,
                        isSelected: selectedSort == option,
                        action: {
                            selectedSort = option
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
                    Text("Sort")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .presentationDetents([.height(200), .medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(25)
    }
}

