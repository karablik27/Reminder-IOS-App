import SwiftUI

struct SortOptionRow: View {
    let option: SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var description: String {
        switch option {
        case .byDate:
            return "You will see events sorted by date.".localized
        case .byName:
            return "You will see events sorted by name.".localized
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description.localized)
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
    @Binding var selectedSort: SortOption
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(SortOption.allCases, id: \.self) { option in
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
                    Text("Sort".localized)
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
