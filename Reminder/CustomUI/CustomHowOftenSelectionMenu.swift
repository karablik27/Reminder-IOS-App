import SwiftUI

struct CustomHowOftenSelectionMenuAddEvent: View {
    @Binding var isPresented: Bool
    @Binding var selectedHowOften: ReminderFrequency
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ReminderFrequency.allCases, id: \.self) { freq in
                    HowOftenOptionRowAddEvent(
                        freq: freq,
                        isSelected: selectedHowOften == freq,
                        action: {
                            selectedHowOften = freq
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
                    Text("How Often")
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

struct HowOftenOptionRowAddEvent: View {
    let freq: ReminderFrequency
    let isSelected: Bool
    let action: () -> Void
    
    // Можно задать описание для каждого варианта
    var description: String {
        switch freq {
        case .everyHour:
            return "Repeat every 1 hour."
        case .everyDay:
            return "Repeat every 1 day."
        case .everyWeek:
            return "Repeat every 1 week."
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "star.fill" : "star")
                    .foregroundColor(isSelected ? .black : .gray)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(freq.rawValue)
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

